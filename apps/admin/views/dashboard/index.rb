module Admin::Views::Dashboard
  class Index
    include Admin::View

    def delete_link(item)
      # link_to routes.item_path(id: item.id),
      link_to "/admin/items/#{item.id}",
        id: "delete_item_#{item.id}",
        :'data-confirm' => 'Are you sure you want to delete this item permanently?',
        :'data-method' => 'delete' do
          i "", class: 'fa fa-trash-o fa-lg'
        end
    end

    def form
      form_for :item, '/admin/items' do
        div class: 'input-group input-group-lg' do
          text_field :content, class: 'form-control', placeholder: 'What can I shorten for you today?'
          span class: 'input-group-btn' do
            submit 'Shorten', class: 'btn btn-search', :"data-disable-with" => "Shortening..."
          end
        end
      end
    end
  end
end
