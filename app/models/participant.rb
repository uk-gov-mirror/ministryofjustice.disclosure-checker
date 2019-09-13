class Participant < ApplicationRecord
  def self.valid_reference?(reference)
    Rails.configuration.participants.include?(
      Digest::SHA256.hexdigest(reference)
    )
  end
end
