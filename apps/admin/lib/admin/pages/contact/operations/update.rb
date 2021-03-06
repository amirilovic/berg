require "admin/import"
require "dry-result_matcher"
require "kleisli"
require "types"

module Admin
  module Pages
    module Contact
      module Operations
        class Update
          include Admin::Import(
            "core.persistence.commands.update_office_contact_details"
          )

          include Dry::ResultMatcher.for(:call)

          def call(attributes)
            validation = Validation::Form.(attributes)
            if validation.success?
              about_page_people = update_office_contact_details.(validation.output)
              Right(about_page_people)
            else
              Left(validation)
            end
          end
        end
      end
    end
  end
end
