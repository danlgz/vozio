defmodule VozioWeb.UserSettingsLive do
  use VozioWeb, :live_view

  alias Vozio.Accounts

  def render(assigns) do
    tabs = [
      %{
        title: "Information",
        key: "info",
        navigate: ~p"/users/settings?tab=info"
      },
      %{
        title: "Email",
        key: "email",
        navigate: ~p"/users/settings?tab=email"
      },
      %{
        title: "Password",
        key: "password",
        navigate: ~p"/users/settings?tab=password"
      }
    ]

    assigns = assign(assigns, :tabs, tabs)

    ~H"""
    <.header class="text-center">
      Account Settings
      <:subtitle>Manage your account information, email address, password settings</:subtitle>
    </.header>

    <div class="flex gap-16 mt-16 mx-auto max-w-screen-lg">
      <nav class="flex flex-col gap-4" aria-label="Settings tabs">
        <.link
          :for={tab <- @tabs}
          navigate={tab.navigate}
          class={[
            "px-6 py-4 rounded-full hover:bg-vozio-primary/30 text-center",
            "text-vozio-text-light dark:text-vozio-text-dark",
            @current_tab == tab.key && "bg-vozio-primary/30"
          ]}
        >
          {tab.title}
        </.link>
      </nav>

      <div class={[
        "flex-1 flex flex-col gap-4 w-full p-8 rounded-lg border",
        "bg-vozio-surface-light border-vozio-border-light",
        "dark:bg-vozio-surface-dark dark:border-vozio-border-dark"
      ]}>
        <%= if @current_tab == "info" do %>
          <h2>Account Information</h2>
        <% end %>
        <%= if @current_tab == "email" do %>
          <h2>Change your email</h2>
          <.simple_form
            for={@email_form}
            id="email_form"
            phx-submit="update_email"
            phx-change="validate_email"
          >
            <.input field={@email_form[:email]} type="email" label="Email" required />
            <.input
              field={@email_form[:current_password]}
              name="current_password"
              id="current_password_for_email"
              type="password"
              label="Current password"
              value={@email_form_current_password}
              required
            />
            <:actions>
              <.button phx-disable-with="Changing...">Change Email</.button>
            </:actions>
          </.simple_form>
        <% end %>

        <%= if @current_tab == "password" do %>
          <h2>Change your password</h2>
          <.simple_form
            for={@password_form}
            id="password_form"
            action={~p"/users/log_in?_action=password_updated"}
            method="post"
            phx-change="validate_password"
            phx-submit="update_password"
            phx-trigger-action={@trigger_submit}
          >
            <.input field={@password_form[:password]} type="password" label="New password" required />
            <.input
              field={@password_form[:password_confirmation]}
              type="password"
              label="Confirm new password"
            />
            <.input
              field={@password_form[:current_password]}
              name="current_password"
              type="password"
              label="Current password"
              id="current_password_for_password"
              value={@current_password}
              required
            />
            <input
              name={@password_form[:email].name}
              type="hidden"
              id="hidden_user_email"
              value={@current_email}
            />
            <:actions>
              <.button phx-disable-with="Changing...">Change Password</.button>
            </:actions>
          </.simple_form>
        <% end %>
      </div>
    </div>
    """
  end

  def mount(%{"token" => token}, _session, socket) do
    socket =
      case Accounts.update_user_email(socket.assigns.current_user, token) do
        :ok ->
          put_flash(socket, :info, "Email changed successfully.")

        :error ->
          put_flash(socket, :error, "Email change link is invalid or it has expired.")
      end

    {:ok, push_navigate(socket, to: ~p"/users/settings")}
  end

  def mount(params, _session, socket) do
    user = socket.assigns.current_user
    email_changeset = Accounts.change_user_email(user)
    password_changeset = Accounts.change_user_password(user)

    socket =
      socket
      |> assign(:current_password, nil)
      |> assign(:email_form_current_password, nil)
      |> assign(:current_email, user.email)
      |> assign(:email_form, to_form(email_changeset))
      |> assign(:password_form, to_form(password_changeset))
      |> assign(:trigger_submit, false)
      |> assign(:current_tab, Map.get(params, "tab", "info"))

    {:ok, socket}
  end

  def handle_event("validate_email", params, socket) do
    %{"current_password" => password, "user" => user_params} = params

    email_form =
      socket.assigns.current_user
      |> Accounts.change_user_email(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, email_form: email_form, email_form_current_password: password)}
  end

  def handle_event("update_email", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Accounts.apply_user_email(user, password, user_params) do
      {:ok, applied_user} ->
        Accounts.deliver_user_update_email_instructions(
          applied_user,
          user.email,
          &url(~p"/users/settings/confirm_email/#{&1}")
        )

        info = "A link to confirm your email change has been sent to the new address."
        {:noreply, socket |> put_flash(:info, info) |> assign(email_form_current_password: nil)}

      {:error, changeset} ->
        {:noreply, assign(socket, :email_form, to_form(Map.put(changeset, :action, :insert)))}
    end
  end

  def handle_event("validate_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params

    password_form =
      socket.assigns.current_user
      |> Accounts.change_user_password(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, password_form: password_form, current_password: password)}
  end

  def handle_event("update_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Accounts.update_user_password(user, password, user_params) do
      {:ok, user} ->
        password_form =
          user
          |> Accounts.change_user_password(user_params)
          |> to_form()

        {:noreply, assign(socket, trigger_submit: true, password_form: password_form)}

      {:error, changeset} ->
        {:noreply, assign(socket, password_form: to_form(changeset))}
    end
  end
end
