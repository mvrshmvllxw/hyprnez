import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    visible: true
    width: 600
    height: 750
    color: "#2b2b2b"  // Темный фон

    StackLayout {
        id: stackLayout
        anchors.fill: parent

        // Первый экран с кнопкой
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Button {
                text: "show all keybinds"
                anchors.centerIn: parent
                font.pixelSize: 20
                background: Rectangle {
                    color: "#e91e63"  // Розовая кнопка
                    radius: 10
                }
                onClicked: stackLayout.currentIndex = 1
            }
        }

        // Второй экран с информацией о горячих клавишах
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Column {
                anchors.fill: parent
                spacing: 10
                padding: 20

                Button {
                    text: "← Back"
                    onClicked: stackLayout.currentIndex = 0
                    font.pixelSize: 20
                    background: Rectangle {
                    color: "#e91e63"  // Розовая кнопка
                    radius: 10
                }
                }

                Text {
                    text: "Default Keybinds:\n" +
                        "\n" +
                          "- Win+Q: close window\n" +
                          "- Win+W: toggle window fullscreen\n" +
                          "- Win+E: toggle window floating\n" +
                           "- Win+R: resize but not float\n" +
                           "- Win+T: toggle window split\n" +
                        "\n" +
                          "- Win+1,+2,+3..: switch desktop\n" +
                          "- Win+Shift+1..: move window to desktop\n" +
                          "- Win+mouse_wheel: switch desktop\n" +
                          "- Win+left_mouse: move window\n" +
                          "- Win+right_mouse: resize window\n" +
                           "\n" +
                           "- Win+Z: terminal (Kitty)\n" +
                          "- Win+S: files (Dolphin)\n" +
                          "- Win+X: VS Code\n" +
                          "- Win+D: browser (Firefox)\n" +
                          "- Win+F: Telegram" +
                          "\n" +
                          "- Win+A: apps menu\n" +
                          "- Win+Esc: logout menu\n" +
                          "- Win+Backspace: lock pc\n" +
                          "- CapsLock: change keyboard layout\n" +
                          "- Printscreen: screenshot to clipboard\n" +
                          "- Alt+Prinscreen: screenshot saved to Pictures/Screenshots\n" +
                          "- Win+Printscreen: area screenshot to clipboard\n" +
                          "- lCtrl+Esc: toggle waybar\n\n" +
                          "\n"
                          
                    color: "white"
                    wrapMode: Text.WordWrap
                }
            }
        }
    }
}
