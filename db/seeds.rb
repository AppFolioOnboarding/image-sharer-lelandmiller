images = [].tap do |arr|
  20.times do
    arr << {
      url: 'https://upload.wikimedia.org/wikipedia/commons/a/a5/Flower_poster_2.jpg',
      tag_list: 'flower, good'
    }
  end
end

Image.create(images)
