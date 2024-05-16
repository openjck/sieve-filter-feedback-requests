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
  "What do you think about your recent order?"
] {
  fileinto "${folder}";
}

# Subject contains.
if header :comparator "i;unicode-casemap" :contains "Subject" [
  "How would you rate the support you received?",
  "Would you say you like us, or LIKE LIKE us?",
  "Share Your Feedback",
  "Your Recent Support Request",
  "Please tell us about your experience"
] {
  fileinto "${folder}";
}

# Subject matches.
if header :comparator "i;unicode-casemap" :matches "Subject" [
  "How was your * experience?",
  "tell us about your * experience",
  "Your Voice Matters to *",
  "Please review *",
  "*, share your thoughts on",
  "Helen of Troy Survey *",
  "*, * wants to hear from you",
  "*, please take a few moments to help",
  "we’d love to hear about your * experience"
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
  "*@*.medallia.com"
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

if allof (
  header :comparator "i;unicode-casemap"
         :matches "Subject" "Regarding Your Recent *",
  header :comparator "i;unicode-casemap"
         :matches "Subject" "* Experience"
) {
  fileinto "${folder}";
}
