# WARNING: This migration uses models which could become problematic in the future. Only doing this to avoid
# writing a weird migration for ropes. In production we would prefer avoid using the models in favor of a direct
# database migration.
class EnsureAllImagesHaveTags < ActiveRecord::Migration[5.2]
  def up
    Image.all.each do |image|
      if image.tag_list == []
        image.tag_list = ['needs-tagging']
        image.save
      end
    end
  end
end
