module Item
  def images_count
    count = 0
    count += 1 if self.image_filename_1.present?
    count += 1 if self.image_filename_2.present?
    count += 1 if self.image_filename_3.present?
    return count
  end

  def move
    raise NotImplementedError
  end

  module ClassMethods
    def active_taggings
      ActsAsTaggableOn::Tagging.where(taggable_type: self.name, context: 'categories')
        .includes(:taggable, :tag)
        .select {|tag| tag.try(:taggable).try(:enabled) }
        .reject(&:blank?)
        .sort_by {|tagging| tagging.taggable.id }
    end

    def tagged_items_from_taggings(ary)
      ary.collect(&:taggable).reject(&:blank?)
    end

    def tags_from_taggings(ary)
      ary.collect(&:tag)
          .flatten
          .reject(&:blank?)
          .uniq
          .sort_by(&:name)
    end

    def tag_names_from_taggings(ary)
      tags_from_taggings(ary).reject(&:blank?).collect(&:name).sort
    end

    def first_items_from_tags_from_taggings(ary)
      items = {}
      previous_tag = nil
      ary.each do |tagging|
        current_tag_name = tagging.tag.name
        items[current_tag_name] = tagging.taggable unless items.keys.include?(current_tag_name)
        previous_tag = current_tag_name
      end
      return items.sort.to_h
    end
  end
  def self.included(base)
    base.extend(ClassMethods)
  end
end
