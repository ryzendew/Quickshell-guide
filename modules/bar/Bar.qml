import QtQuick
import Quickshell
import Quickshell.Hyprland
import "../Widgets/"

// Create a proper panel window
PanelWindow {
    id: panel
    
    // Accept volume properties from parent
    property int volume: 0
    property bool volumeMuted: false
    property var defaultAudioSink
    
    // Panel configuration - span full width
    anchors {
        top: true
        left: true
        right: true
    }
    
    implicitHeight: 40
    margins {
        top: 0
        left: 0
        right: 0
    }
    
    // The actual bar content - dark mode
    Rectangle {
        id: bar
        anchors.fill: parent
        color: "#1a1a1a"  // Dark background
        radius: 0  // Full width bar without rounded corners
        border.color: "#333333"
        border.width: 1

        // Workspaces on the far left - connected to Hyprland
        Row {
            id: workspacesRow
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
                leftMargin: 16
            }
            spacing: 8
            
            // Real Hyprland workspace data
            Repeater {
                model: Hyprland.workspaces
                
                Rectangle {
                    width: 32
                    height: 24
                    radius: 20
                    color: modelData.active ? "#4a9eff" : "#333333"
                    border.color: "#555555"
                    border.width: 1
                    
                    // Make workspaces clickable
                    MouseArea {
                        anchors.fill: parent
                        onClicked: Hyprland.dispatch("workspace " + modelData.id)
                    }
                    
                    Text {
                        text: modelData.id
                        anchors.centerIn: parent
                        color: modelData.active ? "#ffffff" : "#cccccc"
                        font.pixelSize: 12
                        font.family: "Inter, sans-serif"
                    }
                }
            }
            
            // Fallback if no workspaces are detected
            Text {
                visible: Hyprland.workspaces.length === 0
                text: "No workspaces"
                color: "#ffffff"
                font.pixelSize: 12
            }
        }

        // System tray widget positioned to the left of volume
        SystemTray {
            id: systemTrayWidget
            bar: panel  // Pass the panel window reference
            anchors {
                right: volumeWidget.left
                verticalCenter: parent.verticalCenter
                rightMargin: 16
            }
        }

        // Volume widget in the center-right area
        Volume {
            id: volumeWidget
            anchors {
                right: timeDisplay.left
                verticalCenter: parent.verticalCenter
                rightMargin: 24
            }
            shell: panel  // Pass the panel as shell reference
            volume: panel.volume  // Pass volume from panel properties
            volumeMuted: panel.volumeMuted  // Pass muted state
        }
        
        // Time on the far right
        Text {
            id: timeDisplay
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
                rightMargin: 16
            }
            
            property string currentTime: ""
            
            text: currentTime
            color: "#ffffff"
            font.pixelSize: 14
            font.family: "Inter, sans-serif"
            
            // Update time every second
            Timer {
                interval: 1000
                running: true
                repeat: true
                onTriggered: {
                    var now = new Date()
                    timeDisplay.currentTime = Qt.formatDate(now, "MMM dd") + " " + Qt.formatTime(now, "hh:mm:ss")
                }
            }
            
            // Initialize time immediately
            Component.onCompleted: {
                var now = new Date()
                currentTime = Qt.formatDate(now, "MMM dd") + " " + Qt.formatTime(now, "hh:mm:ss")
            }
        }
    }
} 