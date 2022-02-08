Jekyll::Hooks.register :posts, :pre_render do |post|
    # get the current post created time
    create_time = File.birthtime( post.path )
  
    # inject create_time in post's datas.
    post.data['created'] = create_time
  
  end