module ApplicationHelper

  def rating_counts_pluralizer(movie, value)
    if value.in? %w(like hate)
      pluralize(movie.send("#{value.pluralize}_count"), value)
    end
  end

  def link_to_undo(rating)
    content = content_tag(:p, class: "delete-wrapper") do
      raw("You #{rating.positive? ? "like" : "hate"} this movie | " +
      (link_to("Un#{rating.positive? ? "like" : "hate" }", rating, method: :delete)))
    end
  end

end
