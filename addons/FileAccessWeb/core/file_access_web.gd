class_name FileAccessWeb
extends RefCounted

signal load_started(file_name: String)
signal loaded(file_name: String, file_type: String, base64_data: String)
signal progress(current_bytes: int, total_bytes: int)
signal error()
signal upload_cancelled()

var _file_uploading: JavaScriptObject

var _on_file_load_start_callback: JavaScriptObject
var _on_files_loaded_callback: JavaScriptObject 
var _on_file_progress_callback: JavaScriptObject
var _on_file_error_callback: JavaScriptObject
var _on_file_cancelled_callback: JavaScriptObject

func _init() -> void:
	if _is_not_web():
		_notify_error()
		return

	JavaScriptBridge.eval(js_source_code, true)
	_file_uploading = JavaScriptBridge.get_interface("godotFileAccessWeb")
	
	_on_file_load_start_callback = JavaScriptBridge.create_callback(_on_file_load_start)
	_on_files_loaded_callback = JavaScriptBridge.create_callback(_on_files_loaded)
	_on_file_progress_callback = JavaScriptBridge.create_callback(_on_file_progress)
	_on_file_error_callback = JavaScriptBridge.create_callback(_on_file_error)
	_on_file_cancelled_callback = JavaScriptBridge.create_callback(_on_file_cancelled)
	
	_file_uploading.setLoadStartCallback(_on_file_load_start_callback)
	_file_uploading.setLoadedCallback(_on_files_loaded_callback)
	_file_uploading.setProgressCallback(_on_file_progress_callback)
	_file_uploading.setErrorCallback(_on_file_error_callback)
	_file_uploading.setCancelledCallback(_on_file_cancelled_callback)

func open(accept_files: String = "*") -> void:
	if _is_not_web():
		_notify_error()
		return
	
	_file_uploading.setAcceptFiles(accept_files)
	_file_uploading.open()

func _is_not_web() -> bool:
	return OS.get_name() != "Web"

func _notify_error() -> void:
	push_error("File Access Web worked only for HTML5 platform export!")

func _on_file_load_start(args: Array) -> void:
	var file_name: String = args[0]
	load_started.emit(file_name)

func _on_files_loaded(args: Array) -> void:
	var files_js_object = args[0]
	var len: int = files_js_object.length
	for i in range(len):
		var file_data = files_js_object[i]
		var file_name: String = file_data["name"]
		var full_data_url: String = file_data["data"]
		var splitted_args: PackedStringArray = full_data_url.split(",", true, 1)

		if splitted_args.size() < 2:
			continue
			
		var file_type: String = splitted_args[0].get_slice(":", 1).get_slice(";", 0)
		var base64_data: String = splitted_args[1]
		loaded.emit(file_name, file_type, base64_data)

func _on_file_progress(args: Array) -> void:
	var current_bytes: int = args[0]
	var total_bytes: int = args[1]
	progress.emit(current_bytes, total_bytes)

func _on_file_error(args: Array) -> void:
	error.emit()

func _on_file_cancelled(args: Array) -> void:
	upload_cancelled.emit()

const js_source_code = """
function godotFileAccessWebStart() {
    var loadedCallback;
    var progressCallback;
    var errorCallback;
    var loadStartCallback;
    var cancelledCallback;

    var input = document.createElement("input");
    input.setAttribute("type", "file");
    input.multiple = true;

    var interface = {
        setLoadedCallback: (loaded) => loadedCallback = loaded,
        setProgressCallback: (progress) => progressCallback = progress,
        setErrorCallback: (error) => errorCallback = error,
        setLoadStartCallback: (start) => loadStartCallback = start,
        setCancelledCallback: (cancelled) => cancelledCallback = cancelled,
        setAcceptFiles: (files) => input.setAttribute("accept", files),
        open: () => input.click()
    };
    
    input.onchange = (event) => {
        const files = event.target.files;
        if (!files.length) {
            return;
        }

        const results = [];
        let filesProcessed = 0;

        for (const file of files) {
            const reader = new FileReader();

            if (loadStartCallback) {
                loadStartCallback(file.name);
            }

            reader.onload = (readerEvent) => {
                results.push({
                    name: file.name,
                    data: readerEvent.target.result,
                });
                
                filesProcessed++;

                if (filesProcessed === files.length) {
                    if (loadedCallback) {
                        loadedCallback(results);
                    }
                }
            };
            
            reader.onerror = (errorEvent) => {
                if (errorCallback) errorCallback();
            };

            reader.onprogress = (progressEvent) => {
                if (progressEvent.lengthComputable && progressCallback) {
                    progressCallback(progressEvent.loaded, progressEvent.total);
                }
            };
            
            reader.readAsDataURL(file);
        }
    };
    
    input.addEventListener('cancel', () => {
        if (cancelledCallback) cancelledCallback();
    });

    return interface;
}

var godotFileAccessWeb = godotFileAccessWebStart();
"""
