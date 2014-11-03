class PokemonsController < ApplicationController
  def new
    @pokemon = Pokemon.new
  end

  def create
    @pokemon = Pokemon.new(pokemon_params)
    @pokemon.trainer_id = current_trainer.id
    @pokemon.health = 100
    @pokemon.level = 1
    if @pokemon.save
      redirect_to trainer_path(@pokemon.trainer_id)
    else
      flash[:error] = @pokemon.errors.full_messages.to_sentence
      render 'new'
    end
  end

  def capture
    @pokemon = Pokemon.find(params[:id])
    @pokemon.trainer_id = current_trainer.id
    @pokemon.save

    flash[:notice] = "You successfully caught a wild " + @pokemon.name + "!"

    redirect_to root_path
  end

  def damage
    @pokemon = Pokemon.find(params[:id])
  end

  def update
    @pokemon = Pokemon.find(params[:id])
    @fighter = Pokemon.find(params[:fighter]["id"])
    @fighter.level += 1
    @pokemon.health -= 10
    @fighter.save
    @pokemon.save

    flash[:notice] = "Your pokemon " + @fighter.name + " has leveled up and " + @pokemon.name + " has taken damage!"

    redirect_to trainer_path(@pokemon.trainer_id)
  end

  def heal
    @pokemon = Pokemon.find(params[:id])
    @pokemon.health += 10
    @pokemon.save
    redirect_to trainer_path(@pokemon.trainer_id)
  end

  private
    def pokemon_params
      params.require(:pokemon).permit(:name)
    end
end
