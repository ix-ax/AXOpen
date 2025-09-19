export function submitForm(selector, id) {
	const form = document.querySelector(selector);
	form.elements['externalAuthId'].value = id;
	form.submit();
}