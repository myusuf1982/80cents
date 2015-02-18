"use strict"

class Atoms.Organism.Profile extends Atoms.Organism.Dialog

  @url : "/assets/scaffold/admin/organism/dialog.profile.json"

  show: ->
    __.proxy("GET", "profile").then (error, @entity) =>
      @section.form.value @entity
      @section.form.avatar.refresh url: "/assets/uploads/#{@entity.avatar}"
      @section.address.value @entity.address
      super

  # -- Instance Methods --------------------------------------------------------
  onClose: ->
    do @hide
    false

  onChangeAvatar: =>
    @section.form.file.el.trigger "click"
    false

  onFileChange: (event) =>
    event.stopPropagation()
    event.preventDefault()
    file_url = event.target.files[0]
    @section.form.avatar.refresh url: "http://"
    if file_url.type.match /image.*/
      parameters =
        file  : file_url
        id    : @entity.id
        entity: "User"
      __.multipart("POST", "/api/image", parameters).then (error, file) =>
        @section.form.avatar.refresh url: "/assets/uploads/#{file.name}"
        @entity.avatar = file.name
        __.Aside.Menu.header.profile.refresh @entity


  onSave: =>
    parameters = @section.form.value()
    parameters.address = @section.address.value().address
    __.proxy("PUT", "profile", parameters).then (error, @entity) =>
      do @hide
      __.Aside.Menu.header.profile.refresh @entity