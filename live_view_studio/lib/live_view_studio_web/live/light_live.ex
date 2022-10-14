defmodule LiveViewStudioWeb.LightLive do
  @moduledoc """
    #A LiveView module needs to define three callback functions:
    *mount assigns the initial state of the LiveView process
    *handle_event changes the state of the process
    *render renders a new view for the newly-updated state
  """
  use LiveViewStudioWeb, :live_view

  @doc """
    #the mount callback it's the first callback that's invoked when the request comes in throught the router
    *params is a map containing the current query params, as well as any router parameters
    *session is a map containing private session data
    *socket is a struct representing the websocket connection
  """
  def mount(_params, _session, socket) do
    #socket strcut sotre the state of a LiveView process
    socket = assign(socket, :brightness, 10)
    #Calling assign this way returns a new socket struct with :brightness set to 10
    {:ok, socket}
  end

  @doc """
    The render function takes assigns which is the map of key/value pairs
    we assigned to the socket in mount
  """
  def render(assigns) do
    #~H sigil which defines an inlined LiveView template
    #Inside the template we can access the current brightness value using @brightness and interpolate it in an EEx tag:
    ~H"""
      <h1>Front Porch Light</h1>
      <div class="meter">
        <span style={"width: #{@brightness}%"}>
          <%= @brightness %>%
        </span>
      </div>
      <!--phx-click is unique of LiveView, off and on is the name of event-->
      <button phx-click="off">
        Off
      </button>
      <button phx-click="on">
        On
      </button>
      <button phx-click="down">
        Down
      </button>

      <button phx-click="up">
        Up
      </button>
    """
  end

  @doc """
    #The handle_event callback takes three arguments:
      *the name of the event (on in this case)
      *metadata related to the event which we’ll ignore
      *the socket which, remember, has the current state of our live view assigned to it
  """
  def handle_event("on", _, socket) do
    #the render function is automatically called to render a new view with the newly-updated state.
    socket = assign(socket, :brightness, 100)
    {:noreply, socket}
  end

  def handle_event("off", _, socket) do
    socket = assign(socket, :brightness, 0)
    {:noreply, socket}
  end

  #Logical way
  #def handle_event("down", _, socket) do
  #  brightness = socket.assigns.brightness - 10
  #  socket = assign(socket, :brightness, brightness)
  #  {:noreply, socket}
  #end

  #def handle_event("up", _, socket) do
  #  brightness = socket.assigns.brightness + 10
  #  socket = assign(socket, :brightness, brightness)
  #  {:noreply, socket}
  #end

  #With the update function
  def handle_event("down", _, socket) do
    socket = update(socket, :brightness, fn b -> max(b - 10, 0) end)
    {:noreply, socket}
  end

  def handle_event("up", _, socket) do
    socket = update(socket, :brightness, fn b -> min(b + 10, 100) end)
    {:noreply, socket}
  end

end
