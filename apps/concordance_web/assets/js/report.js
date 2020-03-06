import socket from './socket'

(function() {
    // let id = $('#id').data('id')
    // if(!id)
    //     return;
    
    let channel = socket.channel("report:get", {});

    channel.on("update_report", event =>{
        console.log("update report");
    })

    channel.join()
    .receive("ok", resp => { console.log("Joined successfully report", resp) })
    .receive("error", resp => { console.log("Unable to join", resp) })
}) ();