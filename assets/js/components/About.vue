<template>
  <div id="about">
    <div class="content">
      <div class="top-background">
        <div class="logo">MasudaStream</div>
        <div class="main-title">
          <h1>MasudaStream</h1>
        </div>
        <div class="sub-title">
          <a href="/" class="button top-button">エントリーを見る</a>
        </div>
      </div>
      <div class="description">
        <div class="topic">
          <div class="title">
            <h2>はてな匿名ダイアリーの新着ブックマークを見やすく</h2>
          </div>
          <div class="row">
            <div class="left">
              ブックマークがついたはてな匿名ダイアリーだけを時系列順に並べたエントリー．無限スクロールで匿名ダイアリーを過去のダイアリーまで遡れる
            </div>
            <div class="right">
              <img src="/images/entries.png" />
            </div>
            <div class="clearfix"></div>
          </div>
        </div>
      </div>
      <div class="description description-inverse">
        <div class="topic">
          <div class="title">
            <h2>ダイアログでブックマークコメントをチェック</h2>
          </div>
          <div class="row">
            <div class="left">
              <img src="/images/entry_show.png" />
            </div>
            <div class="right">
              ダイアログで記事本文とブックマークコメントを一度にチェックできる．気に入った記事があればそこからブックマークを追加することもできる．
            </div>
            <div class="clearfix"></div>
          </div>
        </div>
      </div>
    </div>
    <footer>
      <p>&copy; 2019 <a href="https://pleroma.io/users/h3poteto" target="_blank">@h3poteto@pleroma.io</a></p>
    </footer>
  </div>
</template>

<script>
export default {
  name: 'about'
}
</script>

<style lang="scss" scoped>
#about {
  background-color: #fff;

  .top-background {
    background: url('/images/about_background.jpeg') no-repeat;
    background-position: 50% 50%;
    background-size: cover;
    color: var(--extra-light-border-color);
    height: 40rem;
    min-height: 70%;
    width: 100%;

    .logo {
      font-size: large;
      padding: 8px 16px;
    }

    .main-title {
      max-width: 70rem;
      width: 80%;
      margin: 0 auto;
      padding-top: 11.25rem;
      text-align: right;

      h1 {
        font-size: 3rem;
        font-weight: 400;
      }
    }

    .sub-title {
      margin-top: 5rem;
      text-align: center;

      .top-button {
        background-color: var(--blue-color);
        border: 0;
        border-radius: 4px;
        color: var(--extra-light-border-color);
        font-size: large;
        padding: 8px 32px;
        text-decoration: none;
      }
    }
  }

  .description {
    padding: 3rem 0;

    .topic {
      max-width: 70rem;
      width: 65%;
      margin: 0 auto;
    }

    .title {
      margin: 0 0 2rem;
      text-align: center;

      h2 {
        font-weight: 400;
      }
    }

    .row {
      .left {
        float: left;
        max-width: 45%;
      }

      .right {
        float: right;
        max-width: 45%;
      }

      img {
        width: 100%;
      }
    }
  }

  .description-inverse {
    background: url('/images/about_description.jpg') no-repeat;
    background-position: 50% 50%;
    background-size: cover;
    color: var(--extra-light-border-color);
  }

  footer {
    padding: 2rem 0;
    text-align: center;
  }
}
</style>
