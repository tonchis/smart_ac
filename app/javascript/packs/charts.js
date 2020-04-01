export const changeChart = (type, chartId, url, options) => {
    // alert(url)

    
  new Chartkick[type](chartId, url, options);
}