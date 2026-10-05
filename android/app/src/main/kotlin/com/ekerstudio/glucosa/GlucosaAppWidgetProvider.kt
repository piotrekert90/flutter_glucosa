package com.ekerstudio.glucosa

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.content.res.Configuration
import android.graphics.Color
import android.os.Bundle
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetPlugin
import es.antonborri.home_widget.HomeWidgetProvider

/** Compact (2x1) home screen widget showing the latest glucose reading. */
class GlucosaAppWidgetProvider : HomeWidgetProvider() {

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        if (intent.action == Intent.ACTION_CONFIGURATION_CHANGED) {
            val appWidgetManager = AppWidgetManager.getInstance(context)
            val thisWidget = ComponentName(context, GlucosaAppWidgetProvider::class.java)
            val appWidgetIds = appWidgetManager.getAppWidgetIds(thisWidget)
            onUpdate(context, appWidgetManager, appWidgetIds, HomeWidgetPlugin.getData(context))
        }
    }

    override fun onAppWidgetOptionsChanged(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        newOptions: Bundle?
    ) {
        super.onAppWidgetOptionsChanged(context, appWidgetManager, appWidgetId, newOptions)
        onUpdate(context, appWidgetManager, intArrayOf(appWidgetId), HomeWidgetPlugin.getData(context))
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        val isSystemDark = (context.resources.configuration.uiMode and Configuration.UI_MODE_NIGHT_MASK) ==
            Configuration.UI_MODE_NIGHT_YES
        val layoutId = if (isSystemDark) R.layout.widget_glucosa_dark else R.layout.widget_glucosa

        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, layoutId).apply {
                val hasData = widgetData.getBoolean("has_data", false)
                if (!hasData) {
                    setViewVisibility(R.id.widget_content_container, View.GONE)
                    setViewVisibility(R.id.widget_empty_view, View.VISIBLE)
                } else {
                    setViewVisibility(R.id.widget_content_container, View.VISIBLE)
                    setViewVisibility(R.id.widget_empty_view, View.GONE)

                    val value = widgetData.getString("glucose_value", "--") ?: "--"
                    val unit = widgetData.getString("glucose_unit", "mg/dL") ?: "mg/dL"
                    val status = widgetData.getString("status", "inRange") ?: "inRange"
                    val trend = widgetData.getString("trend", "flat") ?: "flat"
                    val trendText = widgetData.getString("trend_text", "") ?: ""

                    setTextViewText(R.id.widget_header_title, widgetData.getString("header_title", "Glucosa"))
                    setTextViewText(R.id.widget_glucose_value, value)
                    setTextViewText(R.id.widget_glucose_unit, unit)
                    setTextColor(R.id.widget_glucose_value, statusColor(status))

                    val arrow = when (trend) {
                        "up" -> "↑ "
                        "down" -> "↓ "
                        else -> ""
                    }
                    setTextViewText(R.id.widget_trend_text, arrow + trendText)
                    setTextColor(R.id.widget_trend_text, statusColor(status))
                }

                val pendingIntent = HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java)
                setOnClickPendingIntent(R.id.widget_root, pendingIntent)
                setOnClickPendingIntent(R.id.widget_action_btn, pendingIntent)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }

    private fun statusColor(status: String): Int = when (status) {
        "hypoglycemia", "hyperglycemia" -> Color.parseColor("#D32F2F")
        "low", "high" -> Color.parseColor("#EF6C00")
        else -> Color.parseColor("#2E7D32")
    }
}
