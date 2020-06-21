ActiveAdmin.register User do
  belongs_to :unit, optional: true
 
  includes :rank, :country

  actions :index, :show, :edit, :update

  permit_params :rank_id, :last_name, :first_name, :middle_name,
    :name_prefix, :steam_id, :forum_member_id, :country_id

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :rank
      f.input :last_name
      f.input :first_name
      f.input :middle_name
      f.input :name_prefix
      f.input :country
      f.input :steam_id, :as => :string
      f.input :forum_member_id
    end
    f.actions
  end

  filter :rank
  filter :last_name
  filter :first_name
  filter :country
  filter :steam_id
  filter :forum_member_id

  scope :active, default: true
  scope :all

  index do
    selectable_column
    column :last_name
    column :first_name
    column :middle_name
    column :rank
    column :country
    column 'Steam ID', :steam_id
    column 'Forum ID', :forum_member_id
    actions
  end

  sidebar 'Related records', only: [:show, :edit] do
    ul do
      li link_to 'Assignments', admin_user_assignments_path(resource)
      li link_to 'User awards', admin_user_user_awards_path(resource)
      li link_to 'Passes', admin_user_passes_path(resource)
    end
  end

  after_save do |user|
    user.update_coat
  end
end
