import QtQuick 2.3
import DMusic 1.0

Rectangle {
    color: "transparent"

    SongListView {
        id: songListView
        datamodel: SearchOnlineSongListModel
    }

    // LocalController {
    //     localSongsView: songListView.view
    // }
}