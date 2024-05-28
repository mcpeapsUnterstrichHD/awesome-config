-- WARNING: Este é um widget muito rudimentar, e atualiza a cada 10 segundos. Ou seja
-- se a bateria for conectada a um carregador, o sinalzinho só vai atualizar
-- depois de até 10 segundos
-- Tenho que aprender a usar d-bus pra atualizar instantâneamente

local awful = require "awful"
local naughty = require "naughty"
local T = {}

T.notificacao = nil

-- Esta função retorna a tabela do widget de bateria
T.widget = awful.widget.watch(
    "sh -c 'upower -i $(upower -e | grep BAT) | grep -E \"state|percentage\" | sed -e \'s/percentage://g\' | sed -e \'s/state://g\''",
    10,
    function(widget, stdout, stderr, exitreason, exitcode)
        local lines = {}
        -- Separa as linhas
        for s in stdout:gmatch("[^%s\n]+") do
            table.insert(lines, s)
        end
        local state = lines[1]
        local charging = nil
        state, charging = T.charging(state)
        local bateria = lines[2]
        local icon = T.icon(bateria)
        local text = state .. icon .. " " .. bateria
        widget:set_text(text)
        T.low_battery(bateria, charging)
    end
)

T.charging = function(state)
    local text = ""
    local charging = false
    if state == "charging" then
        text = "󱐋"
        charging = true
        if T.notificacao then
            naughty.destroy(T.notificacao, naughty.notificationClosedReason.dismissedByUser)
        end
        T.notificacao = nil
    end
    return text, charging
end

-- Essa função exibe uma notificação e um som quando a bateria está baixa
T.low_battery = function(bateria, charging)
    -- Não emitir notificação se estiver carregando
    if charging then return end

    local i, j = bateria:find("%d+")
    bateria = bateria:sub(i, j)
    bateria = tonumber(bateria) or 0

    if bateria <= 25
    then
        if T.notificacao == nil then
            T.notificacao = naughty.notify {
                preset = naughty.config.presets.critical,
                title = "Bateria baixa",
                text = "󰂃 " .. bateria .. "%",
            }
        else
            naughty.replace_text(T.notificacao, "Bateria baixa", "󰂃 " .. bateria .. "%")
        end
    end
end

T.icon = function(bateria)
    local i, j = bateria:find("%d+")
    bateria = bateria:sub(i, j)
    bateria = tonumber(bateria) or 0
    local icon = ""
    if bateria <= 10 then
        icon = "󰁺"
    elseif bateria <= 20 then
        icon = "󰁻"
    elseif bateria <= 30 then
        icon = "󰁼"
    elseif bateria <= 40 then
        icon = "󰁽"
    elseif bateria <= 50 then
        icon = "󰁾"
    elseif bateria <= 60 then
        icon = "󰁿"
    elseif bateria <= 70 then
        icon = "󰂀"
    elseif bateria <= 80 then
        icon = "󰂁"
    elseif bateria <= 90 then
        icon = "󰂂"
    elseif bateria <= 100 then
        icon = "󰁹"
    end
    return icon
end

return T
