#!/usr/bin/env bash

# Lightweight i18n helper for macbook-battery-shortcuts.
# Supported languages:
#   en = English
#   pt = Português do Brasil
#   es = Español
#
# Add new languages by adding <lang>:<key> cases for every key.

# shellcheck shell=bash

t() {
	local key="$1"
	shift || true

	case "${LANG_CHOICE:-en}:$key" in
	en:language_prompt) echo "Select language / Selecione o idioma / Seleccione idioma:" ;;
	en:choice_prompt) echo "Choice [1]: " ;;
	en:language_en) echo "[1] English (default)" ;;
	en:language_pt) echo "[2] Português do Brasil" ;;
	en:language_es) echo "[3] Español" ;;
	en:intro_title) echo "MacBook Battery Shortcuts" ;;
	en:intro_body)
		cat <<'EOT'
This installer configures terminal shortcuts for Apple Silicon MacBook battery charge management.

Lithium-ion batteries age faster when they spend long periods at high charge levels, especially with heat. For users who keep a MacBook plugged in most of the day, maintaining the battery around 70–80% is a practical, conservative strategy to reduce battery stress while keeping enough charge for short unplugged use.
EOT
		;;
	en:shortcuts_intro)
		cat <<'EOT'
This setup will create terminal shortcuts:

  batt-7080     Normal daily mode: maintain 70–80%
  batt-80       Simple daily mode: maintain 80%
  batt-away     Prepare for use away from charger: allow charging to 100%
  batt-stat     Show battery status
  batt-midyear  Optional calibration routine, useful only occasionally
EOT
		;;
	en:incompatible_os) echo "This requires macOS." ;;
	en:incompatible_arch) echo "This requires an Apple Silicon." ;;
	en:current_arch) echo "Current architecture:" ;;
	en:aborted) echo "Installation aborted before making changes." ;;
	en:install_mode_title) echo "Choose installation type:" ;;
	en:install_mode_cli)
		cat <<'EOT'
[1] CLI only (default)
    Recommended for terminal users.
    Installs only the command-line battery tool.
    No graphical app is installed.
EOT
		;;
	en:install_mode_gui)
		cat <<'EOT'
[2] Full app + CLI
    Installs the graphical Battery app and the CLI.
    You will need to open the app once to complete permissions/setup.
EOT
		;;
	en:install_mode_prompt) echo "Choice [1]: " ;;
	en:installing_cli) echo "Installing battery CLI only..." ;;
	en:installing_gui) echo "Installing Battery app + CLI..." ;;
	en:homebrew_required) echo "Homebrew is required for full app installation. Install Homebrew first or rerun this installer and choose CLI only." ;;
	en:open_app_now) echo "Open the Battery app now to complete setup? [Y/n] " ;;
	en:installing_shortcuts) echo "Installing terminal shortcuts..." ;;
	en:activate_now) echo "Activate daily 70–80% mode now? [Y/n] " ;;
	en:command_not_found) echo "battery command not found yet. Restart terminal or run: source ~/.zshrc" ;;
	en:done) echo "Setup complete." ;;
	en:activate_shortcuts) echo "To activate shortcuts in this terminal, run:" ;;
	en:available_shortcuts) echo "Available shortcuts:" ;;

	pt:language_prompt) echo "Select language / Selecione o idioma / Seleccione idioma:" ;;
	pt:choice_prompt) echo "Opção [1]: " ;;
	pt:language_en) echo "[1] English (default)" ;;
	pt:language_pt) echo "[2] Português do Brasil" ;;
	pt:language_es) echo "[3] Español" ;;
	pt:intro_title) echo "Atalhos de Bateria do MacBook" ;;
	pt:intro_body)
		cat <<'EOT'
Este instalador configura atalhos de terminal para gerenciamento de carga da bateria em MacBooks Apple Silicon.

Baterias de íons de lítio envelhecem mais rápido quando passam longos períodos em níveis altos de carga, especialmente com calor. Para quem usa o MacBook conectado à tomada durante a maior parte do dia, manter a bateria na faixa de 70–80% é uma estratégia prática e conservadora para reduzir o estresse da bateria sem perder autonomia para usos curtos fora da tomada.
EOT
		;;
	pt:shortcuts_intro)
		cat <<'EOT'
Esta configuração criará atalhos no terminal:

  batt-7080     Uso diário normal: manter entre 70–80%
  batt-80       Uso diário simples: manter em 80%
  batt-away     Preparar para uso longe do carregador: liberar carga até 100%
  batt-stat     Mostrar status da bateria
  batt-midyear  Calibração opcional, útil apenas ocasionalmente
EOT
		;;
	pt:incompatible_os) echo "Isso requer macOS." ;;
	pt:incompatible_arch) echo "Isso requer um Apple Silicon." ;;
	pt:current_arch) echo "Arquitetura atual:" ;;
	pt:aborted) echo "Instalação abortada antes de fazer alterações." ;;
	pt:install_mode_title) echo "Escolha o tipo de instalação:" ;;
	pt:install_mode_cli)
		cat <<'EOT'
[1] Apenas CLI (padrão)
    Recomendado para usuários habituais de terminal.
    Instala somente a ferramenta de linha de comando battery.
    Nenhum aplicativo gráfico será instalado.
EOT
		;;
	pt:install_mode_gui)
		cat <<'EOT'
[2] Aplicativo completo + CLI
    Instala o aplicativo gráfico Battery e a CLI.
    Será necessário abrir o aplicativo uma vez para concluir permissões/configuração.
EOT
		;;
	pt:install_mode_prompt) echo "Opção [1]: " ;;
	pt:installing_cli) echo "Instalando apenas a CLI battery..." ;;
	pt:installing_gui) echo "Instalando aplicativo Battery + CLI..." ;;
	pt:homebrew_required) echo "Homebrew é necessário para instalar o aplicativo completo. Instale o Homebrew primeiro ou execute este instalador novamente escolhendo apenas CLI." ;;
	pt:open_app_now) echo "Deseja abrir o app Battery agora para concluir a configuração? [S/n] " ;;
	pt:installing_shortcuts) echo "Instalando atalhos no terminal..." ;;
	pt:activate_now) echo "Deseja ativar agora o modo diário 70–80%? [S/n] " ;;
	pt:command_not_found) echo "Comando battery ainda não encontrado. Reinicie o terminal ou execute: source ~/.zshrc" ;;
	pt:done) echo "Configuração concluída." ;;
	pt:activate_shortcuts) echo "Para ativar os atalhos neste terminal, execute:" ;;
	pt:available_shortcuts) echo "Atalhos disponíveis:" ;;

	es:language_prompt) echo "Select language / Selecione o idioma / Seleccione idioma:" ;;
	es:choice_prompt) echo "Opción [1]: " ;;
	es:language_en) echo "[1] English (default)" ;;
	es:language_pt) echo "[2] Português do Brasil" ;;
	es:language_es) echo "[3] Español" ;;
	es:intro_title) echo "Accesos directos de batería del MacBook" ;;
	es:intro_body)
		cat <<'EOT'
Este instalador configura accesos directos del terminal para gestionar la carga de la batería en MacBooks Apple Silicon.

Las baterías de iones de litio envejecen más rápido cuando pasan largos periodos con niveles altos de carga, especialmente con calor. Para quienes usan el MacBook conectado a la corriente la mayor parte del día, mantener la batería entre 70–80% es una estrategia práctica y conservadora para reducir el estrés de la batería sin perder autonomía para usos cortos sin cargador.
EOT
		;;
	es:shortcuts_intro)
		cat <<'EOT'
Esta configuración creará accesos directos en el terminal:

  batt-7080     Uso diario normal: mantener entre 70–80%
  batt-80       Uso diario simple: mantener en 80%
  batt-away     Preparar para uso lejos del cargador: permitir carga hasta 100%
  batt-stat     Mostrar estado de la batería
  batt-midyear  Calibración opcional, útil solo ocasionalmente
EOT
		;;
	es:incompatible_os) echo "Esto requiere macOS." ;;
	es:incompatible_arch) echo "Esto requiere un Apple Silicon." ;;
	es:current_arch) echo "Arquitectura actual:" ;;
	es:aborted) echo "Instalación cancelada antes de realizar cambios." ;;
	es:install_mode_title) echo "Elige el tipo de instalación:" ;;
	es:install_mode_cli)
		cat <<'EOT'
[1] Solo CLI (predeterminado)
    Recomendado para usuarios habituales del terminal.
    Instala solo la herramienta de línea de comandos battery.
    No se instalará la aplicación gráfica.
EOT
		;;
	es:install_mode_gui)
		cat <<'EOT'
[2] Aplicación completa + CLI
    Instala la aplicación gráfica Battery y la CLI.
    Será necesario abrir la aplicación una vez para completar permisos/configuración.
EOT
		;;
	es:install_mode_prompt) echo "Opción [1]: " ;;
	es:installing_cli) echo "Instalando solo la CLI battery..." ;;
	es:installing_gui) echo "Instalando aplicación Battery + CLI..." ;;
	es:homebrew_required) echo "Homebrew es necesario para instalar la aplicación completa. Instala Homebrew primero o ejecuta este instalador de nuevo y elige solo CLI." ;;
	es:open_app_now) echo "¿Quieres abrir la app Battery ahora para completar la configuración? [S/n] " ;;
	es:installing_shortcuts) echo "Instalando accesos directos en el terminal..." ;;
	es:activate_now) echo "¿Quieres activar ahora el modo diario 70–80%? [S/n] " ;;
	es:command_not_found) echo "El comando battery aún no se encontró. Reinicia el terminal o ejecuta: source ~/.zshrc" ;;
	es:done) echo "Configuración completada." ;;
	es:activate_shortcuts) echo "Para activar los accesos directos en este terminal, ejecuta:" ;;
	es:available_shortcuts) echo "Accesos directos disponibles:" ;;

	en:calibration_reminder_last) echo "Reminder: your last calibration was $1 days ago." ;;
	en:calibration_reminder_none) echo "Reminder: no calibration has been recorded since setup $1 days ago." ;;
	en:calibration_reminder_reason) echo "Consider at least one calibration per year to keep battery percentage estimates accurate." ;;
	en:calibration_reminder_action) echo "Use batt-midyear when convenient." ;;
	en:setting_7080) echo "Setting daily mode: maintain 70-80%..." ;;
	en:setting_80) echo "Setting simple daily mode: maintain 80%..." ;;
	en:away_mode) echo "Preparing for use away from charger: allowing charge to 100%..." ;;
	en:away_restore) echo "When back to normal plugged-in use, run:" ;;
	en:calibration_title) echo "Optional calibration routine." ;;
	en:calibration_hint) echo "Use this only occasionally, for example once or twice per year, or if battery percentage estimates seem wrong." ;;
	en:calibration_confirm) echo "Type YES to start calibration: " ;;
	en:calibration_cancelled) echo "Calibration cancelled." ;;
	en:calibration_recorded) echo "Midyear calibration date recorded:" ;;
	en:calibration_after) echo "After calibration completes, restore daily mode with:" ;;
	en:cli_missing) echo "battery CLI not found. Try reinstalling or restarting your terminal." ;;

	pt:calibration_reminder_last) echo "Lembrete: sua última calibração foi há $1 dias." ;;
	pt:calibration_reminder_none) echo "Lembrete: nenhuma calibração foi registrada desde a configuração, há $1 dias." ;;
	pt:calibration_reminder_reason) echo "Considere fazer pelo menos uma calibração por ano para manter as estimativas de porcentagem da bateria mais precisas." ;;
	pt:calibration_reminder_action) echo "Use batt-midyear quando for conveniente." ;;
	pt:setting_7080) echo "Ativando modo diário: manter entre 70-80%..." ;;
	pt:setting_80) echo "Ativando modo diário simples: manter em 80%..." ;;
	pt:away_mode) echo "Preparando para uso longe do carregador: liberando carga até 100%..." ;;
	pt:away_restore) echo "Quando voltar ao uso normal conectado à tomada, execute:" ;;
	pt:calibration_title) echo "Rotina opcional de calibração." ;;
	pt:calibration_hint) echo "Use apenas ocasionalmente, por exemplo uma ou duas vezes por ano, ou se as estimativas de porcentagem da bateria parecerem erradas." ;;
	pt:calibration_confirm) echo "Digite YES para iniciar a calibração: " ;;
	pt:calibration_cancelled) echo "Calibração cancelada." ;;
	pt:calibration_recorded) echo "Data da calibração registrada:" ;;
	pt:calibration_after) echo "Depois que a calibração terminar, restaure o modo diário com:" ;;
	pt:cli_missing) echo "CLI battery não encontrada. Tente reinstalar ou reiniciar o terminal." ;;

	es:calibration_reminder_last) echo "Recordatorio: tu última calibración fue hace $1 días." ;;
	es:calibration_reminder_none) echo "Recordatorio: no se ha registrado ninguna calibración desde la configuración, hace $1 días." ;;
	es:calibration_reminder_reason) echo "Considera hacer al menos una calibración al año para mantener más precisas las estimaciones de porcentaje de batería." ;;
	es:calibration_reminder_action) echo "Usa batt-midyear cuando te resulte conveniente." ;;
	es:setting_7080) echo "Activando modo diario: mantener entre 70-80%..." ;;
	es:setting_80) echo "Activando modo diario simple: mantener en 80%..." ;;
	es:away_mode) echo "Preparando para uso lejos del cargador: permitiendo carga hasta 100%..." ;;
	es:away_restore) echo "Cuando vuelvas al uso normal conectado a la corriente, ejecuta:" ;;
	es:calibration_title) echo "Rutina opcional de calibración." ;;
	es:calibration_hint) echo "Úsala solo ocasionalmente, por ejemplo una o dos veces al año, o si las estimaciones de porcentaje de batería parecen incorrectas." ;;
	es:calibration_confirm) echo "Escribe YES para iniciar la calibración: " ;;
	es:calibration_cancelled) echo "Calibración cancelada." ;;
	es:calibration_recorded) echo "Fecha de calibración registrada:" ;;
	es:calibration_after) echo "Cuando termine la calibración, restaura el modo diario con:" ;;
	es:cli_missing) echo "CLI battery no encontrada. Intenta reinstalar o reiniciar el terminal." ;;

	*) echo "Missing translation: ${LANG_CHOICE:-en}:$key" ;;
	esac
}
