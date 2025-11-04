thematic_shiny()

custom_theme <- bs_theme(
  version = 5,
  # Настройка цветов
  bg = "#000000",           # фон
  fg = "#ffd700",           # основной текст
  primary = "#d40612",      # основной цвет
  secondary = "#d40612",    # второстепенный цвет
  success = "#a30810",      # успех
  warning = "#8b040b67",      # предупреждение
  danger = "#961e24",       # опасность
  # Настройка шрифтов
  base_font = font_google("Open Sans"),
  heading_font = font_google("Roboto")
)

# to synchronise themes with plots
thematic_on(bg = "auto", fg = "auto", accent = "auto")
