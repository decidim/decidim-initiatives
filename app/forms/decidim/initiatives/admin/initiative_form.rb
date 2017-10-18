# frozen_string_literal: true

module Decidim
  module Initiatives
    module Admin
      # A form object used to show the initiative data for technical validation.
      class InitiativeForm < Form
        include TranslatableAttributes

        mimic :initiative

        translatable_attribute :title, String
        translatable_attribute :description, String
        attribute :type_id, Integer
        attribute :decidim_scope_id, Integer
        attribute :signature_type, String
        attribute :signature_start_time, Date
        attribute :signature_end_time, Date
        attribute :hashtag, String

        translatable_attribute :answer, String
        attribute :answer_url, String

        validates :title, :description, presence: true
        validates :signature_type, presence: true
        validates :signature_start_time, presence: true, if: ->(form) { form.context.initiative.published? }
        validates :signature_end_time, presence: true, if: ->(form) { form.context.initiative.published? }
        validates :signature_end_time, date: { after: :signature_start_time }, if: ->(form) {
          form.signature_start_time.present? && form.signature_end_time.present?
        }

        validates :answer, translatable_presence: true, if: ->(form) { form.context.initiative.accepted? }
        validates :answer_url, presence: true, if: ->(form) { form.context.initiative.accepted? }

        def map_model(model)
          self.type_id = model.type.id
          self.decidim_scope_id = model.scope.id
        end

        def available_locales
          Decidim.available_locales
        end
      end
    end
  end
end
