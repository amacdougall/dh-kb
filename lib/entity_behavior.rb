# Behaviors common to all entity classes.
module EntityBehavior
  # Returns the first sentence of the description field. Does its best to
  # handle sentences which end in quotations or parentheses. If it fails
  # to find the end of the first sentence, it displays a 25-word excerpt
  # followed by an ellipsis.
  def short_description
    terminator = description.match /[.?!]['"]?($| )/

    if not terminator.nil?
      description[0..terminator.offset(0).first]
    else
      description.split(" ")[0..25].join(" ") + "..."
    end
  end

  # Returns the entity's description, with mention tags converted to Markdown
  # links. Mention tags take the following format: @[name][type:id], where the
  # type is the lowercase plural of the model class name.
  def description_markdown
    tags_to_links description
  end

  # Returns the entity's shortened description, with mention tags converted to
  # Markdown links. Mention tags take the following format: @[name][type:id],
  # where the type is the lowercase plural of the model class name.
  def short_description_markdown
    tags_to_links short_description
  end


  private
  # Returns the supplied text, with mention tags converted to Markdown links.
  # Mention tags take the following format: @[name][type:id], where the type is
  # the lowercase plural of the model class name.
  def tags_to_links(text)
    text.gsub /@\[([^\]]+)\]\((\w+)\:(\d+)\)/, "[\\1](/\\2/\\3)"
  end
end
