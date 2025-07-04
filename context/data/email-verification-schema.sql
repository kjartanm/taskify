-- Email Verification Schema Extension
-- Add email verification support to the existing schema

-- Add email verification columns to parents table
ALTER TABLE parents ADD COLUMN email_verified BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE parents ADD COLUMN email_verified_at DATETIME NULL;

-- Create email verification tokens table
CREATE TABLE email_verification_tokens (
    token_id TEXT PRIMARY KEY,
    parent_id TEXT NOT NULL,
    email TEXT NOT NULL,
    token_hash TEXT NOT NULL UNIQUE,
    expires_at DATETIME NOT NULL,
    used_at DATETIME NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    invalidated_at DATETIME NULL,
    
    -- Foreign key constraints
    FOREIGN KEY (parent_id) REFERENCES parents(parent_id) ON DELETE CASCADE,
    
    -- Constraints
    CONSTRAINT chk_token_expiry CHECK (expires_at > created_at),
    CONSTRAINT chk_email_format CHECK (
        email LIKE '%_@_%.__%' AND 
        LENGTH(email) <= 254 AND 
        LENGTH(email) >= 5
    )
);

-- Create indexes for performance
CREATE INDEX idx_email_verification_tokens_parent_id ON email_verification_tokens(parent_id);
CREATE INDEX idx_email_verification_tokens_token_hash ON email_verification_tokens(token_hash);
CREATE INDEX idx_email_verification_tokens_email ON email_verification_tokens(email);
CREATE INDEX idx_email_verification_tokens_expires_at ON email_verification_tokens(expires_at);
CREATE INDEX idx_parents_email_verified ON parents(email_verified);

-- Create trigger to update parent's updated_at when email is verified
CREATE TRIGGER trg_update_parent_on_email_verification
    AFTER UPDATE OF email_verified ON parents
    FOR EACH ROW
    WHEN NEW.email_verified = TRUE AND OLD.email_verified = FALSE
BEGIN
    UPDATE parents 
    SET updated_at = CURRENT_TIMESTAMP,
        email_verified_at = CURRENT_TIMESTAMP
    WHERE parent_id = NEW.parent_id;
END;
