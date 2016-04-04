Hanami::Model.migration do
  change do
  	alter_table :items do
  	  add_column :title,	String,	null: true,	text: true
  	end
  end
end
