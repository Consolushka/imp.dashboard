// API присылает день без времени, браузер считает его полуночью по UTC: без явного пояса западнее Гринвича показался бы предыдущий день
export const formatBlockDate = (date) =>
  new Date(date).toLocaleDateString('en-US', {
    month: 'short',
    day: 'numeric',
    year: 'numeric',
    timeZone: 'UTC'
  }).toUpperCase()
