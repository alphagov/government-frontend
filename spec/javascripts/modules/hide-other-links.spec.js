describe('A hide-other-links module', function () {
  var list
  var GOVUK = window.GOVUK

  function subject () {
    $('body').append(list)
    var instance = new GOVUK.Modules.HideOtherLinks(list[0])
    instance.init()
  }

  afterEach(function () {
    list.remove()
  })

  describe('with a list of more than 2 links', function () {
    beforeEach(function () {
      list = $(
        '<dd class="animals">' +
          '<a href="http://en.wikipedia.org/wiki/dog">Dog</a>, ' +
          '<a href="http://en.wikipedia.org/wiki/cat">Cat</a>, ' +
          '<a href="http://en.wikipedia.org/wiki/cow">Cow</a> and ' +
          '<a href="http://en.wikipedia.org/wiki/pig">Pig</a>.' +
        '</dd>'
      )

      subject()
    })

    it('groups elements into other-content span', function () {
      expect($('.animals .other-content').children().length).toBe(3)
    })

    it('creates a link to show hidden content', function () {
      expect($('.animals .show-other-content').length).toBe(1)
    })

    it('has the correct count in the link', function () {
      var otherCount = $('.animals .other-content').find('a').length
      var linkCount = $('.animals .show-other-content').text().match(/\d+/).pop()
      expect(parseInt(linkCount, 10)).toBe(otherCount)
    })

    it('sets the correct aria value', function () {
      expect($('.animals').attr('aria-live')).toEqual('polite')
    })
  })

  describe('with a list of 2 short links', function () {
    beforeEach(function () {
      list = $(
        '<dd class="animals">' +
          '<a href="http://en.wikipedia.org/wiki/dog">Dog</a>, ' +
          '<a href="http://en.wikipedia.org/wiki/cat">Cat</a>, ' +
        '</dd>'
      )

      subject()
    })

    it('does not hide any links', function () {
      expect($('.animals .other-content').length).toBe(0)
    })
  })

  describe('with a list of 2 long links', function () {
    beforeEach(function () {
      list = $(
        '<dd class="long-words">' +
          '<a href="http://en.wikipedia.org/wiki/Lopado­temacho­selacho­galeo­kranio­leipsano­drim­hypo­trimmato­silphio­parao­melito­katakechy­meno­kichl­epi­kossypho­phatto­perister­alektryon­opte­kephallio­kigklo­peleio­lagoio­siraio­baphe­tragano­pterygon">Lopado­temacho­selacho­galeo­kranio­leipsano­drim­hypo­trimmato­silphio­parao­melito­katakechy­meno­kichl­epi­kossypho­phatto­perister­alektryon­opte­kephallio­kigklo­peleio­lagoio­siraio­baphe­tragano­pterygon</a>, ' +
          '<a href="http://en.wikipedia.org/wiki/Pneumonoultramicroscopicsilicovolcanoconiosis">Pneumonoultramicroscopicsilicovolcanoconiosis</a>, ' +
        '</dd>'
      )

      subject()
    })

    it('hides the links', function () {
      expect($('.long-words .other-content').children().length).toBe(1)
    })
  })
})
