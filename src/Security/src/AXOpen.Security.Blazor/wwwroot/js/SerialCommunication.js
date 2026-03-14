var reading = false;
var reader;
var closePromise;
const STORAGE_KEY = "preferredSerialPortInfo";

async function onDataReceivedAsync(data, serialService) {
	try {
		await serialService.invokeMethodAsync("OnDataReceived", data);
	}
	catch (ex) {
		console.log("Error calling OnDataReceived: " + ex.message);
	}
}

async function onDeviceInfoReceivedAsync(deviceInfo, serialService) {
	try {
		await serialService.invokeMethodAsync("OnDeviceInfoReceived", deviceInfo.usbVendorId, deviceInfo.usbProductId);
	}
	catch (ex) {
		console.log("Error calling OnDeviceInfoReceived: " + ex.message);
	}
}

async function readUntilClosedAsync(port, serialService) {
	while (port.readable && reading) {
		reader = port.readable.getReader();
		try {
			while (true) {
				let { value, done } = await reader.read();
				if (done) break;
				await onDataReceivedAsync(value, serialService);
			}
		}
		catch (ex) {
			console.log("Serial error: " + ex.message);
		}
		finally {
			reader.releaseLock();
		}
	}

	await port.close();

	if (reading)
		serialService.invokeMethodAsync("OnSerialError")
}

function savePreferredPortInfo(info) {
	try {
		localStorage.setItem(STORAGE_KEY, JSON.stringify(info || {}));
	} catch (ex)
	{
		console.log("Local storage error, when trying to save preferred port info: " + ex.message);
	}
}

function loadPreferredPortInfo() {
	try {
		const raw = localStorage.getItem(STORAGE_KEY);
		return raw ? JSON.parse(raw) : null;
	} catch (ex) {
		console.log("Local storage error, when trying to load preferred port info: " + ex.message);
		return null;
	}
}

export function forgetPreferredSerialPort() {
	try {
		localStorage.removeItem(STORAGE_KEY);
	} catch (ex) {
		console.log("Local storage error, when trying to remove preferred port info: " + ex.message);
	}
}

function infoMatches(a, b) {
	if (!a || !b) return false;
	const aV = a.usbVendorId ?? null, aP = a.usbProductId ?? null, aB = a.bluetoothServiceClassId ?? null;
	const bV = b.usbVendorId ?? null, bP = b.usbProductId ?? null, bB = b.bluetoothServiceClassId ?? null;
	return aV === bV && aP === bP && aB === bB;
}

async function tryOpenPreviouslyAuthorizedPortAsync(openOptions, preferredInfo) {
	const ports = await navigator.serial.getPorts(); // Only pre-authorized ports
	if (!ports.length) return null;

	// Prefer an exact match to what we stored; otherwise, if no preference, try the first.
	let candidate = preferredInfo
		? ports.find(p => infoMatches(p.getInfo?.() ?? {}, preferredInfo))
		: ports[0];

	if (!candidate) return null;

	await candidate.open(openOptions);
	return candidate;
}

async function openPortDialogAsync(openOptions) {
	let port = await navigator.serial.requestPort();
	await port.open(openOptions);
	return port;
}

export async function openPortAsync(serialService, onlyPreviouslyAuthorizedPort, baudRate, bufferSize, dataBits, flowControl, parity, stopBits) {
	if (!('serial' in navigator)) {
		return 11; // Web Serial API not supported in this browser.
	}

	const openOptions = { baudRate, bufferSize, dataBits, flowControl, parity, stopBits };

    // Load preferred port info
	const preferred = loadPreferredPortInfo();
	let port = null;

	try {
		// Try previously authorized
		try {
			port = await tryOpenPreviouslyAuthorizedPortAsync(openOptions, preferred);
		} catch (ex) {
			port = null;
		}
		// Open dialog
		if (!port) {
			if (onlyPreviouslyAuthorizedPort) {
                return 12; // No previously authorized port found.
			}

			port = await openPortDialogAsync(openOptions);
		}
		const info = port.getInfo?.() ?? {};
		// Save preferred port info
		savePreferredPortInfo(info);
        // Notify device info
		await onDeviceInfoReceivedAsync(info, serialService);
		// Read data
		reading = true;
		closePromise = readUntilClosedAsync(port, serialService);
		return 0;
	}
	catch (ex) {
		try {
			await port.close();
		} catch { }

		if (ex.name == "SecurityError")
			return 13;
		else if (ex.name == "InvalidStateError")
			return 14;
		else if (ex.name == "NetworkError")
			return 15;
		return 1;
	}
}

export async function closePortAsync(){
	reading = false;
	reader.cancel();
	await closePromise;
}
