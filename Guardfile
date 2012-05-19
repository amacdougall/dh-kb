# Execute shell commands on file change.
guard :shell  do
  watch %r{^app/coffeescript} do |m|
    # coffee -> javascript
    `coffee -c -o public/javascript/ app/coffeescript/*.coffee`

    # informative message
    n "Coffeescript file #{m[0]} was changed", "Regenerating site", :success
  end
end
