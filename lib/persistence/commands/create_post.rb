module Persistence
  module Commands
    class CreatePost < ROM::Commands::Create[:sql]
      relation :posts
      register_as :create
      result :one

      def execute(tuple)
        result = super

        post_id = result.first[:id]

        if tuple[:post_categories]
          categories = tuple[:post_categories].product([post_id])

          post_tupples = categories.map do |category_id, post_id|
            {
              category_id: category_id,
              post_id: post_id
            }
          end

          categorisations.multi_insert(post_tupples)
        end

        result
      end

      private

      def categorisations
        relation.categorisations
      end
    end
  end
end
