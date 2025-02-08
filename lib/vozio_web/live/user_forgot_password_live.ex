defmodule VozioWeb.UserForgotPasswordLive do
  use VozioWeb, :live_view

  alias Vozio.Accounts

  def render(assigns) do
    ~H"""
    <div class={[
      "mx-auto max-w-md p-6 rounded-lg mt-20",
      "bg-vozio-surface-light dark:bg-vozio-surface-dark",
      "border border-vozio-border-light dark:border-vozio-border-dark"
    ]}>
      <.header class="text-center mb-8">
        Forgot your password?
        <:subtitle>We'll send a password reset link to your inbox</:subtitle>
      </.header>

      <.simple_form for={@form} id="reset_password_form" phx-submit="send_email">
        <.input field={@form[:email]} type="email" placeholder="Email" required />
        <:actions>
          <div class="flex justify-center w-full">
            <.button phx-disable-with="Sending...">
              Send password reset instructions
            </.button>
          </div>
        </:actions>
      </.simple_form>
      <p class="text-center text-sm mt-4">
        <.link href={~p"/users/register"}>Register</.link>
        | <.link href={~p"/users/log_in"}>Log in</.link>
      </p>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{}, as: "user"))}
  end

  def handle_event("send_email", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_reset_password_instructions(
        user,
        &url(~p"/users/reset_password/#{&1}")
      )
    end

    info =
      "If your email is in our system, you will receive instructions to reset your password shortly."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> redirect(to: ~p"/")}
  end
end
