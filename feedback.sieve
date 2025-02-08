require [
  "include",
  "environment",
  "variables",
  "relational",
  "comparator-i;ascii-numeric",
  "spamtest",
  "fileinto",
  "imap4flags"
];

# Generated: When using Proton Mail, do not run this script on spam messages.
if allof (
  environment :matches "vnd.proton.spam-threshold" "*",
  spamtest :value "ge" :comparator "i;ascii-numeric" "${1}"
) {
  return;
}

# This is the folder that matching messages should be moved to.
set "folder" "Filtered out";

################################################################################
# Subject filters
################################################################################

# Subject is exactly.
if header :comparator "i;unicode-casemap" :is "Subject" [
  "Tell us how we did",
  "How did we do?",
  "How was your stay?",
  "Media Usage Survey",
  "What do you think about your recent order?",
  "How was our store today?",
  "Thank you for joining us! What’s next?",
  "Mind answering a quick question?",
  "How happy were you with our service?"
] {
  fileinto "${folder}";
}

# Subject contains.
if header :comparator "i;unicode-casemap" :contains "Subject" [
  "How would you rate the support you received?",
  "Would you say you like us, or LIKE LIKE us?",
  "Share Your Feedback",
  "Your Recent Support Request",
  "Please tell us about your experience",
  "Your opinion is important to us!`",
  "your feedback is requested",
  "Feedback Request",
  "Let us know what you think",
  "How do you like"
] {
  fileinto "${folder}";
}

# Subject matches.
if header :comparator "i;unicode-casemap" :matches "Subject" [
  "How was your * experience?",
  "Your voice matters to *",
  "Please review*purchase*",
  "*, share your thoughts on",
  "Helen of Troy Survey *",
  "*, * wants to hear from you",
  "*, please take a few moments to help",
  "*love to hear about your * experience*",
  "Your opinion * to us!",
  "Please rate your recent *",
  "How satisfied are you with *",
  "We'd love feedback *",
  "Survey about *",
  "How would you rate *",
  "Tell us about your *",
  "Tell us what you think about *",
  "*how did * do?*",
  "How are you feeling about*"
  "Regarding Your Recent * Experience"
] {
  fileinto "${folder}";
}

################################################################################
# From address filters
################################################################################

# From address is exactly.
if address :all :comparator "i;unicode-casemap" :is "From" [
  "thankyou@getwherewolf.com"
] {
  fileinto "${folder}";
}

# From address matches.
if address :all :comparator "i;unicode-casemap" :matches "From" [
  "*@survey.*.*",
  "*@feedback.*.*",
  "*@*.medallia.com",
  "*@invites.listen360.com"
] {
  fileinto "${folder}";
}

################################################################################
# Complex filters
################################################################################

if allof (
  header :comparator "i;unicode-casemap"
         :matches "Subject" "How was your * with *",
  address :all :comparator "i;unicode-casemap"
          :matches "From" "*stellaconnect.net"
) {
  fileinto "${folder}";
}

if allof (
  header :comparator "i;unicode-casemap"
         :matches "Subject" "How's your trip going, *\\?",
  address :all :comparator "i;unicode-casemap"
          :matches "From" "*hotels.com"
) {
  fileinto "${folder}";
}

if allof (
  header :comparator "i;unicode-casemap"
         :matches "Subject" "How was your recent visit at *",
  address :all :comparator "i;unicode-casemap"
          :matches "From" "*birdeye.com"
) {
  fileinto "${folder}";
}
