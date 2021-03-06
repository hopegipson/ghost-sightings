class GhostsController < ApplicationController

  post '/ghosts' do
      city = City.find_by(id: params[:city_id])
      identical = !!city.ghosts.detect { |ghost| ghost.content == params[:content] || ghost.name == params[:name] }
      if params.values.any?(&:empty?) 
        redirect "/cities/#{params[:city_id]}?error=Invalid submission please try again:"     
      elsif identical
        redirect "/cities/#{params[:city_id]}?error=Ghost already exists, please try again:"     
      else
            @ghost = Ghost.new( name: params[:name], content: params[:content])
            @ghost.user = current_user
            @ghost.users << User.find_by(id: session[:user_id])
            @ghost.cities << City.find(params[:city_id])
            @ghost.save
        end
        redirect "/users/#{current_user.id}"
  end
  
  post '/ghostscheck' do
    if params[:user] != nil
      user = params[:user]
      user["ghost_ids"].each do |number|
        ghost = Ghost.find_by(id: number)
        if !current_user.ghosts.find_by(name: ghost.name)
             ghost.users << current_user
         end
        end
        redirect "/users/#{current_user.id}"
    else
      redirect "/users/#{current_user.id}"
    end
  end
  
  get '/ghosts/leaderboard' do
    erb :'/ghosts/leaderboard.html'
  end

  get '/ghosts/newleaderboard' do
    erb :'/ghosts/newleaderboard.html'
  end
  
  
  get '/ghosts/:id/edit' do    
      @ghost = Ghost.find(params[:id])
      @ghostuser = User.find_by(id: @ghost.user.id)

      if @ghostuser != current_user
        redirect :login
      else
        erb :'/ghosts/edit.html'
      end
  end
  
  patch '/ghosts/:id' do
      ghost = Ghost.find(params[:id])
      if ghost.user.id.to_i == current_user.id
         ghost.update(name: params[:name], content: params[:content])
         redirect "/users/#{current_user.id}"
      else
        redirect "/users/#{current_user.id}?error=Not your ghost selected"
      end
  end
  
  delete '/ghosts/:id/delete' do
      ghost = Ghost.find_by(id: params[:id])
      ghost.destroy if ghost.user.id.to_i == current_user.id
      redirect "/users/#{current_user.id}"
    end
  
  end