describe('A hide-other-links module', function () {
  var container
  var GOVUK = window.GOVUK

  function subject () {
    var instance = new GOVUK.Modules.HideOtherLinks(container.firstElementChild)
    instance.init()
  }

  afterEach(function () {
    document.body.removeChild(container)
  })

  describe('with a list of more than 2 links', function () {
    beforeEach(function () {
      container = document.createElement('div')
      container.innerHTML = `
        <dd class="animals">
          <a href="http://en.wikipedia.org/wiki/dog">Dog</a>, 
          <a href="http://en.wikipedia.org/wiki/cat">Cat</a>, 
          <a href="http://en.wikipedia.org/wiki/cow">Cow</a> and 
          <a href="http://en.wikipedia.org/wiki/pig">Pig</a>.
        </dd>
      `

      document.body.appendChild(container)
      subject()
    })

    it('groups elements into other-content span', function () {
      var otherContent = document.querySelector('.animals .other-content')

      expect(otherContent.childElementCount).toBe(3)
    })

    it('creates a link to show hidden content', function () {
      var showOtherContent = document.querySelector('.animals .show-other-content')

      expect(showOtherContent.childElementCount).toBe(1)
    })

    it('has the correct count in the link', function () {
      var otherCount = document.querySelectorAll('.animals .other-content a').length
      var linkCountText = document.querySelector('.animals .show-other-content').textContent

      expect(linkCountText).toContain(otherCount)
    })

    it('sets the correct aria value', function () {
      var animalsList = document.querySelector('.animals')

      expect(animalsList.getAttribute('aria-live')).toEqual('polite')
    })
  })

  describe('with a list of 2 short links', function () {
    beforeEach(function () {
      container = document.createElement('div')
      container.innerHTML = `
        <dd class="animals">
          <a href="http://en.wikipedia.org/wiki/dog">Dog</a>, 
          <a href="http://en.wikipedia.org/wiki/cat">Cat</a>, 
        </dd>
      `
      document.body.appendChild(container)
      subject()
    })

    it('does not hide any links', function () {
      var otherContent = document.querySelector('.animals .other-content')

      expect(otherContent).toBe(null)
    })
  })

  describe('with a list of 2 long links', function () {
    beforeEach(function () {
      container = document.createElement('div')
      container.innerHTML = `
        <dd class="long-words"> 
          <a href="http://en.wikipedia.org/wiki/Lopado­temacho­selacho­galeo­kranio­leipsano­drim­hypo­trimmato­silphio­parao­melito­katakechy­meno­kichl­epi­kossypho­phatto­perister­alektryon­opte­kephallio­kigklo­peleio­lagoio­siraio­baphe­tragano­pterygon">Lopado­temacho­selacho­galeo­kranio­leipsano­drim­hypo­trimmato­silphio­parao­melito­katakechy­meno­kichl­epi­kossypho­phatto­perister­alektryon­opte­kephallio­kigklo­peleio­lagoio­siraio­baphe­tragano­pterygon</a>, 
          <a href="http://en.wikipedia.org/wiki/Pneumonoultramicroscopicsilicovolcanoconiosis">Pneumonoultramicroscopicsilicovolcanoconiosis</a>, 
        </dd>
      `

      document.body.appendChild(container)
      subject()
    })

    it('hides the links', function () {
      var otherContent = document.querySelector('.long-words .other-content')

      expect(otherContent.childElementCount).toBe(1)
    })
  })
})
