import { Controller } from 'stimulus';
import ClassicEditor from '@ckeditor/ckeditor5-build-classic';

export default class extends Controller {
    connect() {
        ClassicEditor
            .create( this.element )
            .then( editor => {
                editor.plugins.get( 'FileRepository' ).createUploadAdapter = loader => new Adapter( loader );
            })
            .catch(err => {console.log(err)});
    }
}

// import Base64UploadAdapter from '@ckeditor/ckeditor5-upload/src/adapters/base64uploadadapter';
// https://github.com/ckeditor/ckeditor5-upload/blob/master/src/adapters/base64uploadadapter.js#L56-L108
// https://github.com/ckeditor/ckeditor5-angular/issues/126#issuecomment-551266608
class Adapter {
    constructor( loader ) {
        this.loader = loader;
    }
    upload() {
        return new Promise( ( resolve, reject ) => {
            const reader = this.reader = new window.FileReader();

            reader.addEventListener( 'load', () => {
                resolve( { default: reader.result } );
            } );

            reader.addEventListener( 'error', err => {
                reject( err );
            } );

            reader.addEventListener( 'abort', () => {
                reject();
            } );

            this.loader.file.then( file => {
                reader.readAsDataURL( file );
            } );
        } );
    }

    abort() {
        this.reader.abort();
    }
}
