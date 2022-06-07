({
    allowDrop: function(cmp, event, helper){
        console.log("Allow Drop");
        event.preventDefault();
    },
    drag: function(cmp, ev, helper){
        console.log("Drag");

        var parentId = document.getElementById(ev.target.id).parentElement.id;
        cmp.set("v.startId",ev.target.id);
        cmp.set("v.parentId",parentId);
    },
    drop: function(cmp, ev, helper){
        console.log("Drop");

        var drag = cmp.get("v.startId");
        var div = ev.target.id;
        var fragment = document.createDocumentFragment();
        fragment.appendChild(document.getElementById(drag));
        document.getElementById(div).appendChild(fragment);
        var c = document.getElementById(div).children;
        var x = document.getElementById('div2').parentElement.id;
        var fragment = document.createDocumentFragment();
        fragment.appendChild(document.getElementById(c[0].id));
        document.getElementById(cmp.get("v.parentId")).appendChild(fragment);
    }
})