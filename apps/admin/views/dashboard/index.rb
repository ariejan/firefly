module Admin::Views::Dashboard
  class Index
    include Admin::View

    def form
      form_for :item, '/admin/items' do
        div class: 'input-group input-group-lg' do
          text_field :content, class: 'form-control', placeholder: 'What can I shorten for you today?'
          span class: 'input-group-btn' do
            submit 'Shorten', class: 'btn btn-search'
          end
        end
      end
    end
  end
end
