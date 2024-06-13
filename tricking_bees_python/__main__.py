import pygame

from .models import Card, Game

# Initialize Pygame
pygame.init()

# Set up some constants
WINDOW_WIDTH, WINDOW_HEIGHT = 900, 700
FPS = 30

# Set up the game window
window = pygame.display.set_mode((WINDOW_WIDTH, WINDOW_HEIGHT))

CARD_WIDTH, CARD_HEIGHT = 50, 70
CARD_MARGIN = 10
FONT_SIZE = 24

# Set up the font
font = pygame.font.Font(None, FONT_SIZE)

# Create a game
game = Game.from_player_names(["Alice", "Bob", "Charlie", "David"])
game.start_new_subgame()

# Game loop
running = True
clock = pygame.time.Clock()


def draw_card_list(card_list, x, y, playable_cards: list["Card"] | None = None):
    for i, card in enumerate(card_list):
        # Draw the card as a rectangle
        card_rect = pygame.Rect(
            x + i * (CARD_WIDTH + CARD_MARGIN), y, CARD_WIDTH, CARD_HEIGHT
        )
        pygame.draw.rect(window, card.color.value, card_rect)

        # Draw the card value as text
        card_text = str(card.value) if not card.is_queen else "Q"
        card_value_text = font.render(card_text, True, (0, 0, 0))
        window.blit(card_value_text, card_rect.move(10, 10))

        # If the card is disabled, draw a semi-transparent gray rectangle on top
        if playable_cards is not None and card not in playable_cards:
            overlay = pygame.Surface(
                (CARD_WIDTH, CARD_HEIGHT), pygame.SRCALPHA
            )  # Create a new Surface with alpha channel
            overlay.fill((128, 128, 128, 200))  # Fill it with semi-transparent gray
            window.blit(
                overlay, (x + i * (CARD_WIDTH + CARD_MARGIN), y)
            )  # Blit it onto the window


# Stuff for the log:
LOG_WIDTH, LOG_HEIGHT = 200, 100
LOG_MARGIN = 10
LOG_SCROLL_SPEED = 5
LOG_FONT_SIZE = 16
CURRENT_SCROLL = 0
# Set up the font
log_font = pygame.font.Font(None, LOG_FONT_SIZE)


def draw_game_log(game: Game, log_scroll: int, x_0: int, y_0: int):
    # Draw the log
    for i, message in enumerate(game.log.split("\n")):
        # Calculate the y position of the message
        y = i * LOG_FONT_SIZE + log_scroll

        # Only draw the message if it's inside the log area
        if 10 <= y <= 10 + LOG_HEIGHT:
            log_text = log_font.render(message, True, (0, 0, 0))
            window.blit(log_text, (x_0, y_0 + y))


while running:
    # Event handling
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False
        elif event.type == pygame.MOUSEBUTTONDOWN:
            # Get the mouse position
            mouse_pos = pygame.mouse.get_pos()

            # Check each player's hand
            for i, player in enumerate(game.players):
                for j, card in enumerate(player.hand.cards):
                    # Calculate the card's rectangle
                    y_pos = (
                        100 + i * (CARD_HEIGHT + CARD_MARGIN + FONT_SIZE) + FONT_SIZE
                    )
                    card_rect = pygame.Rect(
                        10 + j * (CARD_WIDTH + CARD_MARGIN),
                        y_pos,
                        CARD_WIDTH,
                        CARD_HEIGHT,
                    )

                    # Check if the mouse position is inside the card rectangle
                    if card_rect.collidepoint(mouse_pos):
                        # If it is, remove the card from the player's hand
                        if game.try_play_card(card):
                            CURRENT_SCROLL += LOG_FONT_SIZE
                        break
        elif event.type == pygame.MOUSEWHEEL:
            # Scroll the log if the mouse wheel is used
            if event.y > 0:  # Scroll up
                CURRENT_SCROLL = min(CURRENT_SCROLL + LOG_SCROLL_SPEED, 0)
            else:  # Scroll down
                CURRENT_SCROLL = max(
                    CURRENT_SCROLL - LOG_SCROLL_SPEED,
                    -len(game.log) * FONT_SIZE + LOG_HEIGHT,
                )

    # Game state updates
    # game.update()

    # Draw everything
    window.fill((255, 255, 255))  # Fill the window with white
    # Split the status message into lines
    status_lines = game.status_message.split("\n")

    # Draw each line separately
    for i, line in enumerate(status_lines):
        status_text = font.render(line, True, (0, 0, 0))
        window.blit(status_text, (400, 10 + i * (FONT_SIZE + 10)))
    draw_card_list(game.current_trick, 10, 10)
    for i, player in enumerate(game.players):
        player_text = f"{player.name} ({player.tricks_won} tricks won):"
        if i == game.current_player_index:
            player_text = "--> " + player_text
        player_name = font.render(player_text, True, (0, 0, 0))
        y_pos = 100 + i * (CARD_HEIGHT + CARD_MARGIN + FONT_SIZE)
        window.blit(player_name, (10, y_pos))
        draw_card_list(
            player.hand.cards,
            x=10,
            y=y_pos + FONT_SIZE,
            playable_cards=player.get_playable_cards(
                game.current_player_index == i, game.compulsory_color
            ),
        )

    # Draw the log
    draw_game_log(game, CURRENT_SCROLL, x_0=10, y_0=500)

    pygame.display.flip()  # Update the display

    # Cap the frame rate
    clock.tick(FPS)

pygame.quit()
