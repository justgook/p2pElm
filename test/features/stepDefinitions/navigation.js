const package = require('../../../package.json')
const expect = require('chai').expect
const { defineSupportCode } = require('cucumber')
const serverBrowser = browser.select('server');

defineSupportCode(function ({ Given, When, Then }) {
  When(/^I go to the website "([^"]*)"$/, (url)=> serverBrowser.url(url))

  When(/^Server room "([^"]*)"$/, (url)=> serverBrowser.url(`/#!/server/${url}`))
  When(/^I connect as "([^"]*)"$/, (id)=>  browser.select(id).url("/#!/"))

  Then(/^I expect the title is same as package description$/, () => {
    return expect(serverBrowser.getTitle()).to.be.eql(package.description)
  })
})
