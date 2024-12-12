# app/validators/profanity_validator.rb
class ProfanityValidator < ActiveModel::Validator
    def validate(record)
        profane_words = ["fuck", "shit", "bitch"]  # Replace with actual words

        # Check title and description for profane words
        if profane_words.any? { |word| record.title&.downcase.include?(word) }
            record.errors.add(:title, "contains inappropriate language")
        end

        if profane_words.any? { |word| record.description&.downcase.include?(word) }
            record.errors.add(:description, "contains inappropriate language")
        end
    end
end
