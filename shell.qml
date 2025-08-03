//@ pragma UseQApplication
import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Services.SystemTray
import qs.modules.bar
import qs.modules.dock
import qs.modules.dock.components

ShellRoot {
    id: root

    // Volume properties for Pipewire integration
    property var defaultAudioSink: Pipewire.defaultAudioSink
    property int volume: defaultAudioSink && defaultAudioSink.audio
        ? Math.round(defaultAudioSink.audio.volume * 100)
        : 0
    property bool volumeMuted: defaultAudioSink && defaultAudioSink.audio
        ? defaultAudioSink.audio.muted
        : false

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    // Top bar
    Loader {
        active: true
        sourceComponent: Bar {
            volume: root.volume
            volumeMuted: root.volumeMuted
            defaultAudioSink: root.defaultAudioSink
        }
    }
    
    // Custom dock menu for right-click actions
    CustomDockMenu {
        id: dockMenu
    }
    
    // Dock
    Loader {
        active: true
        sourceComponent: Dock {
            contextMenu: dockMenu
        }
    }
}
