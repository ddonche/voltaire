# Voltaire
> A witty quote proves nothing. - Voltaire

Voltaire provides a very simple way to manage user reputation points. It lets you increase or decrease reputation 
(points, level, whatever you want to call it in your app) as needed, whenever. It is intended to be extremely light-weight,
when all you want to track is some kind of points system and nothing else. 

All you have to do is add a column for reputation in your users table and let Voltaire do the rest.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'voltaire', '~> 0.4.5'
```

And then execute:

    $ bundle install
    
Add a column in your users table using whatever system you'd like to implement (reputation, points, karma, level, etc.).

```ruby
rails generate migration AddReputationToModel reputation:integer
```

Be sure to add a default value of 0 like this:

```ruby
class AddReputationToModel < ActiveRecord::Migration
  def change
    add_column :table_name, :reputation, :integer, default: 0
  end
end
```

Migrate.

```ruby
rails db:migrate
```

## Implementing Voltaire's Powerful Mechanism

Now you're ready to roll. Voltaire has a couple different ways you can increase or decrease the user's reputation score. One method 
is incremental, and is intended for high-volume actions that increase scores by smaller amounts. 

_Note that with any of the minus/plus 
methods, the record is updated by 1 for whatever amount you specify, so if you put that you want a user's score to increase by 100 for 
something, the database will be hit 100 times. For larger amounts, use the up/down methods instead._

To recap:
- incrementing and decrementing by 1 or a small number, use the _plus_ or _minus_ methods below; _this way guards against concurrency_
- increasing and decreasing by larger amounts for rarer actions or if you don't care about concurrency, user _up_ and _down_ methods below

Whichever of the two ways you decide to use, the parameters are the same. Each method takes 3 arguments: 
* _amount_ (the amount you want to increase or decrease by)
* _reputation_ (the database column you want to alter)
* _user_ (the user or item whose points will be increased)

_Note: if you are using any model other than users, you will need to use the_ ```voltaire_plus_other``` , ```voltaire_minus_other```, ```voltaire_up_other``` and ```voltaire_down_other``` _methods_ 
_(instructions farther down)._


## Larger Amounts
Use ```voltaire_up``` and ```voltaire_down``` methods for larger amounts and if you don't worry about concurrency issues. 

```
voltaire_up(amount, reputation, user)
```
and

```
voltaire_down(amount, reputation, user)
```

## Increments/Decrements of 1 or Smaller Amounts
Use ```voltaire_plus``` and ```voltaire_minus``` methods for smaller amounts or if have concurrency issues. These will hit the database
multiple times.

```
voltaire_plus(amount, reputation, user)
```
and

```
voltaire_minus(amount, reputation, user)
```

# Implementation and Examples
To implement it, simply call the method you want in your controller and pass in the parameters. 

## Examples

Here is an implementation of the [acts_as_votable](https://github.com/ryanto/acts_as_votable) gem, which allows users to 
upvote or downvote comments. In the comments_controller.rb file, we pass in our method where we want Voltaire to go to 
town. In the example below, when a user upvotes a comment, the user who made the comment will have their _karma_ increase 
by 1, as karma is the database column in this example. Because it is incrementing and decrementing by 1, and because lots of
users can potentially upvote and downvote simultaneously, we are using the concurrent safe versions:

_comments_controller.rb_

```ruby
def upvote
  @comment.upvote_by current_user
  voltaire_plus(1, :karma, @comment.user_id)
  redirect_to :back
end

def downvote
  @comment.downvote_by current_user
  voltaire_minus(1, :karma, @comment.user_id)
  redirect_to :back
end
```

If you want to increase or decrease by a different amount, simply pass in a different number. It works so that you can even
have several columns in various tables, so you can track different reputations across your app. For example, you might have 
an overall user reputation, but you want to implement a separate reputation for user activity inside a group. Simply repeat
the above steps as needed. 

## Displaying Reputation 
Display the user's reputation wherever you want in any view:

_index.html.erb_

```ruby
<%= link_to blog.user.username, user_path(blog.user) %><br />
<%= blog.user.reputation %>
```

## More Examples
Here we have set up an easy way to toggle an article and make it featured. Any time a user's article gets featured, we have
Voltaire increase their _reputation_ by 250 points. Because an article being featured is a rarer occasion, and because we don't
feel like hitting our database 250 times for this, we use the up/down method.

_articles_controller.rb_

```ruby
def toggle_feature
  if @article.standard?
    @article.featured!
    voltaire_up(250, :reputation, @article.user_id)
    
  elsif @article.featured?
    @article.standard!
    voltaire_down(250, :reputation, @article.user_id)
  end
  
  redirect_to article_path(@article), notice: 'Article status has been updated.'
end
```

Or maybe you want to reward a user with _points_ for posting a new image. 

_images_controller.rb_
```ruby
def create
  @image = current_user.images.build(image_params)

  respond_to do |format|
    if @image.save
      voltaire_up(10, :points, @image.user_id)
      format.html { redirect_to @image, notice: 'Image was a success!' }
    else
      format.html { render :new }
    end
  end
end
```

# Something Besides Users
If you want to implement a score system on something other than users, you will need to pass that in as a fourth parameter.
In the example below, there is a World class for an app that helps writers create new worlds. If we implement a scoring 
system on the world, we can easily see which ones are more fleshed out. The methods in this case will look like this:

```ruby
voltaire_up_other(amount, reputation, user, other)
  
voltaire_down_other(amount, reputation, user, other)

voltaire_plus_other(amount, reputation, user, other)
  
voltaire_minus_other(amount, reputation, user, other)
```

The fourth parameter, other, indicates the class. In this case, it would be ```World```. _This parameter needs to be uppercase._

```ruby
  def create
    @city = City.new(city_params)
    @city.user = current_user

    respond_to do |format|
      if @city.save
        voltaire_plus_other(1, :score, @city.world_id, World)
        format.html { redirect_to @city, notice: 'City was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end
```

Now, the author can easily see which of their worlds (characters, locations, etc.) are more developed, vs. ones that may need more work.
(Maybe they also compete with other authors to get their creations more points.)

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ddonche/voltaire.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

