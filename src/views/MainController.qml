import QtQuick 2.0

Item {
    property var bgImage
	property var titleBar
	property var leftSideBar
	property var webEngineViewPage
    property var playBottomBar
	property var player

    function initConnect(){

        webEngineViewPage.playMusicByID.connect(Web360ApiWorker.getMusicURLByID)
        Web360ApiWorker.playUrl.connect(playMusic)

        playBottomBar.played.connect(playToggle)

        MediaPlayer.positionChanged.connect(updateSlider)
        MediaPlayer.stateChanged.connect(updatePlayBar)
        // player.onPlaying.connect(onPlaying)
        // player.onPaused.connect(onPaused)
        // player.onStopped.connect(onStopped)
        // player.onError.connect(onError)
    }

    function playMusic(url){
        player.stop()
        player.source = url;
        console.log(player.metaData.hasOwnProperty('size'), '---------', player.metaData.size)
        playToggle(true)
    }

    function playToggle(playing){
        if (playing){
            MediaPlayer.play()
            if (MediaPlayer.mediaObject){
               MediaPlayer.d_notifyInterval = 50;
            }
        }else{
            MediaPlayer.pause()
        }
    }

    function updateSlider(position) {
        var rate = position / MediaPlayer.duration;
        playBottomBar.slider.updateSlider(rate);
    }

    function updatePlayBar(state) {
        if (state == 0){
            onStopped();
        }else if (state == 1){
            onPlaying();
        }else if (state == 2){
            onPaused();
        }
    }

    function onPlaying(){
        playBottomBar.playing = true;
        console.log('Playing')
    }

    function onPaused(){
        playBottomBar.playing = false;
        console.log('Paused')
    }

    function onStopped(){
        playBottomBar.playing = false;
        console.log('Stopped')
    }

    // function onError(error, errorString){
    //     playBottomBar.playing = false;
    //     print(error, errorString);
    // }

    function resetSkin() {
        playBottomBar.color = "#282F3F"
        bgImage.source = ''
    }


    function setSkinByImage(url) {
        if (url === undefined){
            url = "../skin/images/bg2.jpg"
        }
        playBottomBar.color = "transparent"
        bgImage.source = url
    }

	Connections {
        target: titleBar
        onShowMinimized: MainWindow.showMinimized()
        onMenuShowed: MenuWorker.showSettingMenu()
        onSimpleWindowShowed: WindowManageWorker.simpleWindowShowed()
    }

    Connections {
        target: playBottomBar.slider
        onSliderRateChanged:{
            print(MediaPlayer.seekable)
            if (MediaPlayer.seekable){
                MediaPlayer.setPosition(MediaPlayer.duration * rate)
            }
        }
    }

    Connections {
        target: leftSideBar
        onSwicthViewByID: {
            if (viewID == 'WebMusic360Page'){
                webEngineViewPage.url = "http://10.0.0.153:8093/";
            }
            else if (viewID == 'MusicManagerPage'){
                webEngineViewPage.url = MusicManageWorker.artistUrl
            }
            else if (viewID == 'PlayListPage'){
                webEngineViewPage.url = "https://www.baidu.com";
            }
            else if (viewID == 'DownloadPage'){
                webEngineViewPage.url = "http://www.oschina.net/";
            }else{
                console.log('--------------No Page--------------');
            }
        }
    }

    Component.onCompleted: {
        initConnect();
    }
}
