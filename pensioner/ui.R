library(shiny)
library(data.table)

###############################
## Define UI for application ##
###############################
ui <- fluidPage(
  
  titlePanel("Klimatsmarta Pensioner"),
  
  sidebarLayout(
    
    sidebarPanel(
      tags$h3("Information"),
      tags$ul(
        tags$li("All information om fonder är hämtad fran Pensionsmyndigheten och Hållbarhetsprofilen.se"),
        tags$li("Verktyget är ej optimerat för mobilskärmar"),
        tags$li("Bokstäverna ÅÄÖ kan ibland falla bort ur text och skapa problem för vissa fonder")),
      tags$i("Rapportera gärna eventuella problem till: "),
      tagList(a("john.sundh@gmail.com", href="mailto:john.sundh@gmail.com")),
      tags$br(),
      tagList(a("Se koden på GitHub", href="https://github.com/johnne/pensioner")),
      tags$hr(),
      tags$h3("Din fond idag:"),
      tagList("Du hittar din fond i din", a("Fondportfölj", href="https://www.pensionsmyndigheten.se/service/fondportfolj/"), "på Pensionsmyndigheten"),
      uiOutput("select_fund"),
      uiOutput("your_fund_infotext"),
      uiOutput("your_fund_name"),
      uiOutput("your_fund_etisk"),
      uiOutput("your_fund_avgift"),
      uiOutput("your_fund_fondtyp"),
      uiOutput("your_fund_risk"),
      uiOutput("your_fund_ydev"),
      uiOutput("your_fund_y5dev"),
      uiOutput("your_fund_avoids"),
      uiOutput("your_fund_comment_info"),
      uiOutput("your_fund_kluster_comm"),
      uiOutput("your_fund_kemiska_comm"),
      uiOutput("your_fund_nuclear_comm"),
      uiOutput("your_fund_vapen_comm"),
      uiOutput("your_fund_alkohol_comm"),
      uiOutput("your_fund_tobak_comm"),
      uiOutput("your_fund_spel_comm"),
      uiOutput("your_fund_porr_comm"),
      uiOutput("your_fund_fossilt_comm"),
      uiOutput("your_fund_kol_comm"),
      uiOutput("your_fund_uran_comm"),
      uiOutput("your_fund_other_comm"),
      uiOutput("your_fund_link_info"),
      uiOutput("your_fund_ppm"),
      uiOutput("your_fund_hprof"),
      tags$hr(),
      tags$h3("Hitta fonder som:"), 
      
      checkboxGroupInput("samma", label="Har samma", inline = TRUE,
                         choices = c("Risk","Fondtyp"), selected = c("Risk","Fondtyp")),
      checkboxGroupInput("criteria", label="Undviker", inline = TRUE,
                         choices = c("Klusterbomber","Kemiska vapen","Kärnvapen","Vapen/krigsmateriel","Alkohol",
                         "Tobak","Spelverksamhet","Pornografi","Fossilt","Kol","Uran","GMO")),
      checkboxInput("allcrit", label="Markera alla"),
      
      tags$hr(),
      tags$h3("Bäst matchande fond:"),
      tags$i("Nedan visas fonden med lägst avgift som matchar"),
      tags$br(),
      tags$i("Om fler fonder matchar visas de i tabellen till höger ->>"),
      tags$br(),
      uiOutput("closest_fund_infotext"),
      uiOutput("closest_fund_name"),
      uiOutput("closest_fund_etisk"),
      uiOutput("closest_fund_avgift"),
      uiOutput("closest_fund_fondtyp"),
      uiOutput("closest_fund_risk"),
      uiOutput("closest_fund_ydev"),
      uiOutput("closest_fund_y5dev"),
      uiOutput("closest_fund_avoids"),
      uiOutput("closest_fund_comment_info"),
      uiOutput("closest_fund_kluster_comm"),
      uiOutput("closest_fund_kemiska_comm"),
      uiOutput("closest_fund_nuclear_comm"),
      uiOutput("closest_fund_vapen_comm"),
      uiOutput("closest_fund_alkohol_comm"),
      uiOutput("closest_fund_tobak_comm"),
      uiOutput("closest_fund_spel_comm"),
      uiOutput("closest_fund_porr_comm"),
      uiOutput("closest_fund_fossilt_comm"),
      uiOutput("closest_fund_kol_comm"),
      uiOutput("closest_fund_uran_comm"),
      uiOutput("closest_fund_other_comm"),
      uiOutput("closest_fund_link_info"),
      uiOutput("closest_fund_ppm"),
      uiOutput("closest_fund_hprof")
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel(title = "Jämfor fonder",
          DT::dataTableOutput("fund_table")
        ),
        tabPanel(title = "Så här byter du fonder",
          tags$br(),
          tags$ul(
            tags$li(tagList("Gå till sidan för att byta fonder på Pensionsmyndigheten (logga in med BankID/Mobilt BankID):",a("https://www.pensionsmyndigheten.se/mina-tjanster/fondtorg/fondbyte", href="https://www.pensionsmyndigheten.se/mina-tjanster/fondtorg/fondbyte"))),
            tags$li("Sök upp de fonder du vill byta till och klicka på '+'-tecknet för att lägga dessa i din portfölj"),
            tags$li("Fördera andelar för fonderna i % och klicka på 'Gå vidare'"),
            tags$li(tagList("Signera.",tags$b("Klart!")))
          )
        )
      )
    )
  )
)