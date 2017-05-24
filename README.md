# Voltaire
> A witty quote proves nothing. - Voltaire

Voltaire provides a very simple way to manage user reputation points. It lets you increase or decrease reputation 
(points, level, whatever you want to call it in your app) as needed, whenever.

All you have to do is add a column for reputation in your users table and let Voltaire do the rest.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'voltaire', '~> 0.1.0'
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

Now you're ready to roll. Voltaire has two methods you can call to increase or decrease the user's reputation score.
It requires three arguments: amount (the amount you want to increase or decrease by), reputation (the database column 
you want to alter), and user (the user whose reputation will be increased).

The two methods are

```
voltaire_up(amount, reputation, user)
```
and

```
voltaire_down(amount, reputation, user)
```
To implement it, simply call the method you want in your controller and pass in the parameters. 

## Examples

Here is an implementation of the [acts_as_votable](https://github.com/ryanto/acts_as_votable) gem, which allows users to upvote or downvote blog posts. In the blog_controller.rb
file, we pass in our method where we want Voltaire to go to town. In the example below, when a user upvotes a blog post, the 
user who created the blog post will have their reputation increase by 1. Same for downvote. 

_blogs_controller.rb_:

```ruby
  def upvote
    @blog.upvote_by current_user
    
    #update user reputation in the database by 1
    voltaire_up(1, :reputation, @blog.user_id)
    redirect_to :back
  end
  
  def downvote
    @glip.downvote_by current_user
    
    #update user reputation in the database by 1
    voltaire_down(1, :reputation, @blog.user_id)
    redirect_to :back
  end
```

If you want to increase or decrease by a different amount, simply pass in a different number. It works so that you can even
have several columns in various tables, so you can track different reputations across your app. For example, you might have 
an overall user reputation, but you want to implement a separate reputation for user activity inside a group. Simply repeat
the above steps as needed. 

Display the user's reputation wherever you want in any view:

_index.html.erb_:

```ruby
<%= link_to blog.user.username, user_path(blog.user) %><br />
<%= blog.user.reputation %>
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ddonche/voltaire.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

