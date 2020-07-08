package ar.com.guzik.collectednotes.editor;

import android.content.Context;
import android.widget.TextView;

import io.noties.markwon.Markwon;
import io.noties.markwon.ext.strikethrough.StrikethroughPlugin;
import io.noties.markwon.inlineparser.BangInlineProcessor;
import io.noties.markwon.inlineparser.EntityInlineProcessor;
import io.noties.markwon.inlineparser.HtmlInlineProcessor;
import io.noties.markwon.inlineparser.MarkwonInlineParserPlugin;
import io.noties.markwon.linkify.LinkifyPlugin;
import io.noties.markwon.syntax.Prism4jSyntaxHighlight;
import io.noties.markwon.syntax.Prism4jThemeDarkula;
import io.noties.markwon.syntax.SyntaxHighlight;
import io.noties.markwon.syntax.SyntaxHighlightPlugin;
import io.noties.prism4j.Prism4j;
import io.noties.prism4j.annotations.PrismBundle;

@PrismBundle(
        include = {"markdown"}
)
public class Highlighter {

    public static Markwon  highLight(Context context, TextView textView) {

        Prism4j prism4j = new Prism4j( new GrammarLocatorDef());
        Prism4jThemeDarkula  prism4jTheme = Prism4jThemeDarkula.create();

     SyntaxHighlight highlight =
            Prism4jSyntaxHighlight.create(prism4j, prism4jTheme);

    // obtain an instance of Markwon
    return  Markwon.builder(context).usePlugin(SyntaxHighlightPlugin.create(prism4j, prism4jTheme))
            .usePlugin(StrikethroughPlugin.create())
            .usePlugin(LinkifyPlugin.create())
            .usePlugin(MarkwonInlineParserPlugin.create(builder -> {
                builder
                        .excludeInlineProcessor(
                                BangInlineProcessor.class)
                        .excludeInlineProcessor(
                                HtmlInlineProcessor.class)
                        .excludeInlineProcessor(EntityInlineProcessor.class);
            }))
            .build();

    }

}
