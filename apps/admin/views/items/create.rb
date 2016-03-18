module Admin::Views::Items
  class Create
    include Admin::View

    template 'items/new'

    def form
      form_for :item, '/admin/items' do
        if !params.valid?
          div class: 'has-error' do
            params.errors.for('item.content').each do |error|
              case error.validation
              when :presence
                label "Please enter a valid URL.", for: :content, class: 'control-label'
              when :format
                label "That does not look like a valid URL!", for: :content, class: 'control-label'
              end
            end
          end
        end

        div class: "input-group input-group-lg #{'has-error' if !params.valid?}" do
          text_field :content, class: 'form-control', placeholder: 'What can I shorten for you today?'
          span class: 'input-group-btn' do
            submit 'Shorten', class: 'btn btn-search'
          end
        end
      end
    end
  end
end
