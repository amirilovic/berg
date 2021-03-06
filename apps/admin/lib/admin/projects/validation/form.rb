require "admin/import"
require "berg/validation/form"

module Admin
  module Projects
    module Validation
      Form = Berg::Validation.Form do
        configure do
          config.messages = :i18n

          option :project_slug_uniqueness_check, Admin::Container["admin.persistence.project_slug_uniqueness_check"]

          def slug_unique?(value)
            project_slug_uniqueness_check.(value)
          end

          def not_eql?(input, value)
            !input.eql?(value)
          end
        end

        required(:title).filled
        required(:client).filled
        required(:intro).filled
        required(:summary).filled
        required(:case_study).filled(:bool?)

        required(:url).maybe(:uri?)
        required(:body).maybe(:str?)
        required(:cover_image).maybe(:hash?)
        required(:assets).each(:hash?)

        # Required in only the edit form
        optional(:slug).filled
        optional(:previous_slug).filled
        optional(:status).filled(included_in?: Types::ProjectStatus.values)
        optional(:published_at).maybe(:time?)

        rule(body: [:body, :case_study]) do |body, case_study|
          case_study.eql?(true).then(body.filled?)
        end

        rule(slug: [:slug, :previous_slug]) do |slug, previous_slug|
          slug.not_eql?(previous_slug).then(slug.slug_unique?)
        end

        rule(published_at: [:status, :published_at]) do |status, published_at|
          status.eql?("published").then(published_at.filled?)
        end
      end
    end
  end
end
