import React, { Component } from 'react';
import { inject } from 'mobx-react';
import Header from './Header';
import Footer from './Footer';
import FeedbackForm from './FeedbackForm';
import FeedbackStore from '../stores/FeedbackStore';

class App extends Component {
  /* Add Prop Types check*/
  render() {
    return (
      <div>
        <Header title="Tell us what you think" />
        <FeedbackForm feedbackStore={new FeedbackStore()} />
        <Footer />
      </div>
    );
  }
}

export default inject('stores')(App);
