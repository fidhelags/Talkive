-- One-time cleanup for legacy chatbot rows that were not tied to user-only scoping.
-- Run this against the Talkive database after backing it up.

DELETE FROM chat_histories
WHERE tutor_id IS NOT NULL;
