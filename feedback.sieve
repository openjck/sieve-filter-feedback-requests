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
  "How did we do?",
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
  "Tell us how we did",
  "How was your stay",
  "How would you rate",
  "Would you say you like us, or LIKE LIKE us?",
  "Share Your Feedback",
  "Your Recent Support Request",
  "Your opinion is important to us!`",
  "your feedback is requested",
  "Feedback Request",
  "Let us know what you think",
  "How do you like",
  "we'd like to hear from you",
  "Share Your Thoughts",
  "We need your feedback", # No you most certainly don't.
  "Review your purchase", # Wasn't paying for it enough?
  "How likely are you to recommend", # Less, now.
  "Tell Us About Your Recent Purchase", # No.
  "Your Voice Matters", # This voice is telling you to go away.
  "we'd still love to hear from you", # I'd still love you to leave me alone.
  "give us your feedback", # Give me a break.
  "Your feedback matters!", # My time matters.
  "Help shape", # Help unburden.
  "we want to hear from you", # I want you to leave me alone.
  "what you think", # I think your email is annoying.
  "How was your recent call", # Better than this email.
  "Tell us how you like", # I like being left alone.
  "feedback is important", # My time is important.
  "How did you like", # I liked it more than this email.
  "tell us about" # No.
] {
  fileinto "${folder}";
}

# Subject matches.
if header :comparator "i;unicode-casemap" :matches "Subject" [
  "How was your * experience?",
  "Your voice matters to *",
  "Please review*purchase*",
  "*, share your thoughts on*",
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
  "How are you feeling about*",
  "Regarding Your Recent * Experience",
  "What d* you think?",
  "Hi *, we have a quick question.",
  "Order * how did it go*"
] {
  fileinto "${folder}";
}

################################################################################
# From address filters
################################################################################

# From address is exactly.
#
# These may seem overly specific, but, when possible, I'd like to avoid
# filtering out meaningful emails, like emails about one's own account (e.g.,
# one's own Survey Monkey account) or emails from hiring staff, for people who
# intend to apply to these companies.
if address :all :comparator "i;unicode-casemap" :is "From" [
  "thankyou@getwherewolf.com",
  "member@surveymonkeyuser.com"
] {
  fileinto "${folder}";
}

# From address matches.
if address :all :comparator "i;unicode-casemap" :matches "From" [
  "*@survey.*.*",
  "*@feedback.*.*",
  "*@*.medallia.com",
  "*@invites.listen360.com",
  "*@qualtrics-survey.com"
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
