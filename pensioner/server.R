options(warn=2)
shinyServer(function(input, output, session) {
  observe({
    x <- input$allcrit
    if (x==TRUE)
      updateCheckboxGroupInput(session, "criteria", selected = c("Klusterbomber","Kemiska vapen","Kärnvapen","Vapen/krigsmateriel","Alkohol",
                                                                 "Tobak","Spelverksamhet","Pornografi","Fossilt","Kol","Uran","GMO"))
    else
      updateCheckboxGroupInput(session, "criteria", selected = c(""))
  })
  get_comment <- function(data, fundname, commkey) {
    cols <- c("Fondföretag","Fondid","Fondnamn","Avgift","Avgiftstyp","Kategori","Fondtyp",
              "Etisk","Snitt (årlig)","Snitt (5 år)","Risk","Hållbarhetsprofilen",
              "Klusterbomber","Kemiska vapen","Kärnvapen","Vapen/krigsmateriel","Alkohol",
              "Tobak","Spelverksamhet","Pornografi","Fossilt","Kol","Uran","GMO","Alkohol_comment",
              "Fossilt_comment","Kemiska_vapen_comment", "Klusterbomber_comment", "Kol_comment",
              "Spelverksamhet_comment", "Kärnvapen_comment", "Pornografi_comment", "Tobak_comment",
              "Uran_comment", "Vapen/krigsmateriel_comment", "Övrigt_comment")
    colnames(data) <- cols
    res <- data[which(data$Fondnamn==fundname),]
    comm <- res[commkey]
    return(comm)
  }
  get_funds <- reactive({
    df <- read.table("fonder.tsv", sep="\t", header=TRUE, encoding = "UTF-8")
    df <- df[,2:ncol(df)]
    cols <- c("Fondföretag","Fondid","Fondnamn","Avgift","Avgiftstyp","Kategori","Fondtyp",
                      "Etisk","Snitt (årlig)","Snitt (5 år)","Risk","Hållbarhetsprofilen",
                      "Klusterbomber","Kemiska vapen","Kärnvapen","Vapen/krigsmateriel","Alkohol",
                      "Tobak","Spelverksamhet","Pornografi","Fossilt","Kol","Uran","GMO","Alkohol_comment",
                      "Fossilt_comment","Kemiska_vapen_comment", "Klusterbomber_comment", "Kol_comment",
                      "Spelverksamhet_comment", "Kärnvapen_comment", "Pornografi_comment", "Tobak_comment",
                      "Uran_comment", "Vapen/krigsmateriel_comment", "Övrigt_comment")
    colnames(df) <- cols
    df
  })
  
  output$select_fund <- renderUI({
    data <- get_funds()
    choices <- append(c(""),sort(as.vector(data$Fondnamn)))
    selectInput(inputId = "yourfund", label = "Din fond (välj ur listan)", choices, selected = "")
  })
  ####################
  ## YOUR FUND INFO ##
  ####################
  output$your_fund_infotext <- renderUI({
    req(input$yourfund)
    tagList(tags$h5("Information om din fond"))
  })
  output$your_fund_name <- renderUI({
    req(input$yourfund)
    tagList(tags$b("Fondnamn: "), input$yourfund)
  })
  output$your_fund_etisk <- renderUI({
    req(input$yourfund)
    data <- get_funds()
    data$Fondnamn <- as.vector(data$Fondnamn)
    res <- data[which(data$Fondnamn==input$yourfund),]
    if (is.na(res$Etisk))
      tagList(tags$b("Etisk märkning: "), "Nej")
    else
      tagList(tags$b("Etisk märkning: "), "Ja", " (",res$Etisk,")")
  })
  output$your_fund_avgift <- renderUI({
    req(input$yourfund)
    data <- get_funds()
    res <- data[which(data$Fondnamn==input$yourfund),]
    avgift <- res$Avgift
    tagList(tags$b("Avgift: "), avgift, "%")
  })
  output$your_fund_fondtyp <- renderUI({
    req(input$yourfund)
    data <- get_funds()
    res <- data[which(data$Fondnamn==input$yourfund),]
    fondtyp <- res$Fondtyp
    tagList(tags$b("Fondtyp: "), fondtyp)
  })
  output$your_fund_risk <- renderUI({
    req(input$yourfund)
    data <- get_funds()
    res <- data[which(data$Fondnamn==input$yourfund),]
    risk <- res$Risk
    tagList(tags$b("Risk: "), risk)
  })
  output$your_fund_ydev <- renderUI({
    req(input$yourfund)
    data <- get_funds()
    res <- data[which(data$Fondnamn==input$yourfund),]
    ydev <- res["Snitt (årlig)"]
    tagList(tags$b("Snittresultat (årlig): "), ydev)
  })
  output$your_fund_y5dev <- renderUI({
    req(input$yourfund)
    data <- get_funds()
    res <- data[which(data$Fondnamn==input$yourfund),]
    y5dev <- res["Snitt (5 år)"]
    tagList(tags$b("Snittresultat (5 år): "), y5dev)
  })
  output$your_fund_ppm <- renderUI({
    req(input$yourfund)
    yourfund <- input$yourfund
    data <- get_funds()
    if (!is.null(yourfund)) {
      res <- data[which(data$Fondnamn==input$yourfund),]
      id  <- res$Fondid
      ppm_link = paste0("https://www.pensionsmyndigheten.se/service/fondtorg/fond/", id)
      url <- a("Mer info hos Pensionsmyndigheten", href=ppm_link)
      if (ppm_link!="")
        tagList(url)
    }
  })
  output$your_fund_hprof <- renderUI({
    req(input$yourfund)
    data <- get_funds()
    colnames(data) <- c("Fondföretag","Fondid","Fondnamn","Avgift","Avgiftstyp","Kategori","Fondtyp",
                        "Etisk","Snitt (årlig)","Snitt (5 år)","Risk","Hallbarhetsprofilen",
                        "Klusterbomber","Kemiska vapen","Kärnvapen","Vapen/krigsmateriel","Alkohol",
                        "Tobak","Spelverksamhet","Pornografi","Fossilt","Kol","Uran","GMO","Alkohol_comment",
                        "Fossilt_comment","Kemiska_vapen_comment", "Klusterbomber_comment", "Kol_comment",
                        "Spelverksamhet_comment", "Kärnvapen_comment", "Pornografi_comment", "Tobak_comment",
                        "Uran_comment", "Vapen/krigsmateriel_comment", "Övrigt_comment")
    res <- data[which(data$Fondnamn==input$yourfund),]
    if (res$Hallbarhetsprofilen!="") {
      hproflink <- as.vector(res$Hallbarhetsprofilen)
      url <- a("Mer info på Hållbarhetsprofilen", href=hproflink)
      tagList(url)
    }
    else
      tagList("")
  })
  output$your_fund_avoids <- renderUI({
    req(input$yourfund)
    data <- get_funds()
    avoids <- c()
    res <- data[which(data$Fondnamn==input$yourfund),]
    for (val in c("Klusterbomber","Kemiska vapen","Kärnvapen","Vapen/krigsmateriel","Alkohol",
                  "Tobak","Spelverksamhet","Pornografi","Fossilt","Kol","Uran","GMO")) {
      if (res[val] == "UNDVIKER") {
        key <- paste(gsub(" ","_",val),"_comment",sep="")
        if (key%in%colnames(data)) {
          comment <- res[key]
          if (comment!="")
            avoids <- append(avoids, paste(val,"*",sep=""))
          else
            avoids <- append(avoids, val)
        }
      }
    }
    tagList(tags$b("Undviker: "), paste(avoids, collapse = ", "))
  })
  output$your_fund_comment_info <- renderUI({
    req(input$yourfund)
    tagList(tags$h6("Kommentarer:"))
  })
  output$your_fund_alkohol_comm <- renderUI({
    req(input$yourfund)
    comm <- get_comment(get_funds(), input$yourfund, "Alkohol_comment")
    if (comm!="")
      tagList(tags$b("Alkohol: "), comm)
    else
      tagList("")
  })
  output$your_fund_kemiska_comm <- renderUI({
    req(input$yourfund)
    comm <- get_comment(get_funds(), input$yourfund, "Kemiska_vapen_comment")
    if (comm!="")
      tagList(tags$b("Kemiska vapen: "), comm)
    else
      tagList("")
  })
  output$your_fund_nuclear_comm <- renderUI({
    req(input$yourfund)
    comm <- get_comment(get_funds(), input$yourfund, "Kärnvapen_comment")
    if (comm!="")
      tagList(tags$b("Kärnvapen: "), comm)
    else
      tagList("")
  })
  output$your_fund_spel_comm <- renderUI({
    req(input$yourfund)
    comm <- get_comment(get_funds(), input$yourfund, "Spelverksamhet_comment")
    if (comm!="")
      tagList(tags$b("Spelverksamhet: "), comm)
    else
      tagList("")
  })
  output$your_fund_tobak_comm <- renderUI({
    req(input$yourfund)
    comm <- get_comment(get_funds(), input$yourfund, "Tobak_comment")
    if (comm!="")
      tagList(tags$b("Tobak: "), comm)
    else
      tagList("")
  })
  output$your_fund_vapen_comm <- renderUI({
    req(input$yourfund)
    comm <- get_comment(get_funds(), input$yourfund, "Vapen/krigsmateriel_comment")
    if (comm!="")
      tagList(tags$b("Vapen/krigsmateriel: "), comm)
    else
      tagList("")
  })
  output$your_fund_kluster_comm <- renderUI({
    req(input$yourfund)
    comm <- get_comment(get_funds(), input$yourfund, "Klusterbomber_comment")
    if (comm!="")
      tagList(tags$b("Klusterbomber: "), comm)
    else
      tagList("")
  })
  output$your_fund_porr_comm <- renderUI({
    req(input$yourfund)
    comm <- get_comment(get_funds(), input$yourfund, "Pornografi_comment")
    if (comm!="")
      tagList(tags$b("Pornografi: "), comm)
    else
      tagList("")
  })
  output$your_fund_fossilt_comm <- renderUI({
    req(input$yourfund)
    comm <- get_comment(get_funds(), input$yourfund, "Fossilt_comment")
    if (comm!="")
      tagList(tags$b("Fossilt: "), comm)
    else
      tagList("")
  })
  output$your_fund_kol_comm <- renderUI({
    req(input$yourfund)
    comm <- get_comment(get_funds(), input$yourfund, "Kol_comment")
    if (comm!="")
      tagList(tags$b("Kol: "), comm)
    else
      tagList("")
  })
  output$your_fund_uran_comm <- renderUI({
    req(input$yourfund)
    comm <- get_comment(get_funds(), input$yourfund, "Uran_comment")
    if (comm!="")
      tagList(tags$b("Uran: "), comm)
    else
      tagList("")
  })
  output$your_fund_other_comm <- renderUI({
    req(input$yourfund)
    comm <- get_comment(get_funds(), input$yourfund, "Övrigt_comment")
    if (comm!="")
      tagList(tags$b("Övrigt: "), comm)
    else
      tagList("")
  })
  output$your_fund_link_info <- renderUI({
    req(input$yourfund)
    tagList(tags$h6("Länkar:"))
  })
  #######################
  ## CLOSEST FUND INFO ##
  #######################
  get_closest_fund <- reactive({
    avail_funds <- filter_funds()
    best <- avail_funds[1,"Fondnamn"]
    selected <- input$fund_table_rows_selected
    if (length(selected))
      best <- avail_funds[selected[length(selected)],"Fondnamn"]
    best
  })
  output$closest_fund_infotext <- renderUI({
    req(input$yourfund)
    best <- get_closest_fund()
    if (!is.na(best))
      tagList(tags$h5("Information om fonden (Klicka på en rad i tabellen för att visa en annan fond)"))
    else
      tagList("")
  })
  output$closest_fund_comment_info <- renderUI({
    req(input$yourfund)
    best <- get_closest_fund()
    if (!is.na(best))
      tagList(tags$h6("Kommentarer:"))
    else
      tagList("")
  })
  output$closest_fund_link_info <- renderUI({
    req(input$yourfund)
    best <- get_closest_fund()
    if (!is.na(best))
      tagList(tags$h6("Länkar:"))
    else
      tagList("")
  })
  
  output$closest_fund_hprof <- renderUI({
    req(input$yourfund)
    best <- get_closest_fund()
    data <- get_funds()
    colnames(data) <- c("Fondföretag","Fondid","Fondnamn","Avgift","Avgiftstyp","Kategori","Fondtyp",
                        "Etisk","Snitt (årlig)","Snitt (5 år)","Risk","Hallbarhetsprofilen",
                        "Klusterbomber","Kemiska vapen","Kärnvapen","Vapen/krigsmateriel","Alkohol",
                        "Tobak","Spelverksamhet","Pornografi","Fossilt","Kol","Uran","GMO","Alkohol_comment",
                        "Fossilt_comment","Kemiska_vapen_comment", "Klusterbomber_comment", "Kol_comment",
                        "Spelverksamhet_comment", "Kärnvapen_comment", "Pornografi_comment", "Tobak_comment",
                        "Uran_comment", "Vapen/krigsmateriel_comment", "Övrigt_comment")
    if (!is.na(best)) {
      best_res <- data[which(data$Fondnamn==best),]
      hproflink <- as.vector(best_res$Hallbarhetsprofilen)
      url <- a("Mer info på Hållbarhetsprofilen", href=hproflink)
      if (hproflink!="")
        tagList(url)
    }
    else
      tagList("")
  })
  
  output$closest_fund_ppm <- renderUI({
    req(input$yourfund)
    best <- get_closest_fund()
    data <- get_funds()
    if (!is.na(best)) {
      best_res <- data[which(data$Fondnamn==best),]
      best_id <- best_res$Fondid
      ppm_link = paste0("https://www.pensionsmyndigheten.se/service/fondtorg/fond/", best_id)
      url <- a("Mer info hos Pensionsmyndigheten", href=ppm_link)
      if (ppm_link!="")
        tagList(url)
    }
  })
  
  output$closest_fund_name <- renderUI({
    req(input$yourfund)
    best <- get_closest_fund()
    if (!is.na(best))
      tagList(tags$b("Fondnamn: "), best)
    else
      tagList(tags$b("Ingen fond hittades. Försök med att tillåta en annan fondtyp eller risk."))
  })
  output$closest_fund_etisk <- renderUI({
    req(input$yourfund)
    data <- get_funds()
    best <- get_closest_fund()
    if (!is.na(best)) {
      best_res <- data[which(data$Fondnamn==best),]
      best_etisk <- best_res$Etisk
      if (is.na(best_etisk))
        best_etisk <- "Nej"
      else
        best_etisk <- "Ja"
      tagList(tags$b("Etisk märkning: "), best_etisk)
    }
    else {
      tagList("")
    }
  })
  output$closest_fund_avgift <- renderUI({
    req(input$yourfund)
    data <- get_funds()
    best <- get_closest_fund()
    if (!is.na(best)) {
      best_res <- data[which(data$Fondnamn==best),]
      best_avgift <- best_res$Avgift
      tagList(tags$b("Avgift: "),best_avgift,"%")
    }
    else
      tagList("")
  })
  output$closest_fund_fondtyp <- renderUI({
    req(input$yourfund)
    data <- get_funds()
    best <- get_closest_fund()
    if (!is.na(best)) {
      best_res <- data[which(data$Fondnamn==best),]
      best_fondtype <- best_res$Fondtyp
      tagList(tags$b("Fondtyp: "),best_fondtype)
    }
    else
      tagList("")
  })
  output$closest_fund_risk <- renderUI({
    req(input$yourfund)
    data <- get_funds()
    best <- get_closest_fund()
    if (!is.na(best)) {
      best_res <- data[which(data$Fondnamn==best),]
      best_risk <- best_res$Risk
      tagList(tags$b("Risk: "), best_risk)
    }
    else
      tagList("")
  })
  output$closest_fund_ydev <- renderUI({
    req(input$yourfund)
    data <- get_funds()
    best <- get_closest_fund()
    if (!is.na(best)) {
      best_res <- data[which(data$Fondnamn==best),]
      best_ydev <- best_res["Snitt (årlig)"]
      tagList(tags$b("Snittresultat (årlig): "), best_ydev)
    }
    else
      tagList("")
  })
  output$closest_fund_y5dev <- renderUI({
    req(input$yourfund)
    data <- get_funds()
    best <- get_closest_fund()
    if (!is.na(best)) {
      best_res <- data[which(data$Fondnamn==best),]
      best_y5dev <- best_res["Snitt (5 år)"]
      tagList(tags$b("Snittresultat (5 år): "), best_y5dev)
    }
    else
      tagList("")
  })
  output$closest_fund_avoids <- renderUI({
    req(input$yourfund)
    data <- get_funds()
    best <- get_closest_fund()
    avoids <- c()
    if (!is.na(best)) {
      res <- data[which(data$Fondnamn==best),]
      for (val in c("Klusterbomber","Kemiska vapen","Kärnvapen","Vapen/krigsmateriel","Alkohol",
                    "Tobak","Spelverksamhet","Pornografi","Fossilt","Kol","Uran","GMO")) {
        if (res[val] == "UNDVIKER") {
          key <- paste(gsub(" ","_",val),"_comment",sep="")
          if (key%in%colnames(data)) {
            comment <- res[key]
            if (comment!="")
              avoids <- append(avoids, paste(val,"*",sep=""))
            else
              avoids <- append(avoids, val)
          }
        }
      }
      tagList(tags$b("Undviker: "), paste(avoids, collapse = ", "))
    }
    else
      tagList("")
  })
  output$closest_fund_alkohol_comm <- renderUI({
    req(input$yourfund)
    best <- get_closest_fund()
    if (!is.na(best)) {
      comm <- get_comment(get_funds(), best, "Alkohol_comment")
      if (comm!="")
        tagList(tags$b("Alkohol: "), comm)
      else
        tagList("")
    }
    else
      tagList("")
  })
  output$closest_fund_kemiska_comm <- renderUI({
    req(input$yourfund)
    best <- get_closest_fund()
    if (!is.na(best)) {
      comm <- get_comment(get_funds(), best, "Kemiska_vapen_comment")
      if (comm!="")
        tagList(tags$b("Kemiska vapen: "), comm)
      else
        tagList("")
    }
    else
      tagList("")
  })
  output$closest_fund_nuclear_comm <- renderUI({
    req(input$yourfund)
    best <- get_closest_fund()
    if (!is.na(best)) {
      comm <- get_comment(get_funds(), best, "Kärnvapen_comment")
      if (comm!="")
        tagList(tags$b("Kärnvapen: "), comm)
      else
        tagList("")
    }
    else
      tagList("")
  })
  output$closest_fund_spel_comm <- renderUI({
    req(input$yourfund)
    best <- get_closest_fund()
    if (!is.na(best)) {
      comm <- get_comment(get_funds(), best, "Spelverksamhet_comment")
      if (comm!="")
        tagList(tags$b("Spelverksamhet: "), comm)
      else
        tagList("")
    }
    else
      tagList("")
  })
  output$closest_fund_tobak_comm <- renderUI({
    req(input$yourfund)
    best <- get_closest_fund()
    if (!is.na(best)) {
      comm <- get_comment(get_funds(), best, "Tobak_comment")
      if (comm!="")
        tagList(tags$b("Tobak: "), comm)
      else
        tagList("")
    }
    else
      tagList("")
  })
  output$closest_fund_vapen_comm <- renderUI({
    req(input$yourfund)
    best <- get_closest_fund()
    if (!is.na(best)) {
      comm <- get_comment(get_funds(), best, "Vapen/krigsmateriel_comment")
      if (comm!="")
        tagList(tags$b("Vapen/krigsmateriel: "), comm)
      else
        tagList("")
    }
    else
      tagList("")
  })
  output$closest_fund_kluster_comm <- renderUI({
    req(input$yourfund)
    best <- get_closest_fund()
    if (!is.na(best)) {
      comm <- get_comment(get_funds(), best, "Klusterbomber_comment")
      if (comm!="")
        tagList(tags$b("Klusterbomber: "), comm)
      else
        tagList("")
    }
    else
      tagList("")
  })
  output$closest_fund_porr_comm <- renderUI({
    req(input$yourfund)
    best <- get_closest_fund()
    if (!is.na(best)) {
      comm <- get_comment(get_funds(), best, "Pornografi_comment")
      if (comm!="")
        tagList(tags$b("Pornografi: "), comm)
      else
        tagList("")
    }
    else
      tagList("")
  })
  output$closest_fund_fossilt_comm <- renderUI({
    req(input$yourfund)
    best <- get_closest_fund()
    if (!is.na(best)) {
      comm <- get_comment(get_funds(), best, "Fossilt_comment")
      if (comm!="")
        tagList(tags$b("Fossilt: "), comm)
      else
        tagList("")
    }
    else
      tagList("")
  })
  output$closest_fund_kol_comm <- renderUI({
    req(input$yourfund)
    best <- get_closest_fund()
    if (!is.na(best)) {
      comm <- get_comment(get_funds(), best, "Kol_comment")
      if (comm!="")
        tagList(tags$b("Kol: "), comm)
      else
        tagList("")
    }
    else
      tagList("")
  })
  output$closest_fund_uran_comm <- renderUI({
    req(input$yourfund)
    best <- get_closest_fund()
    if (!is.na(best)) {
      comm <- get_comment(get_funds(), best, "Uran_comment")
      if (comm!="")
        tagList(tags$b("Uran: "), comm)
      else
        tagList("")
    }
    else
      tagList("")
  })
  output$closest_fund_other_comm <- renderUI({
    req(input$yourfund)
    best <- get_closest_fund()
    if (!is.na(best)) {
      comm <- get_comment(get_funds(), best, "Övrigt_comment")
      if (comm!="")
        tagList(tags$b("Övrigt: "), comm)
      else
        tagList("")
    }
    else
      tagList("")
  })
  
  
  filter_funds <- reactive({
    req(input$yourfund)
    df <- get_funds()
    all_funds <- get_funds()
    #Filtrera fonder
    avoids <- input$criteria
    df_f <- df
    if (!is.null(avoids)) {
      for (a in avoids) {
        df_f <- df_f[which(df_f[a]=="UNDVIKER"),]
      }
    }
    # Vald fond
    fund_name <- input$yourfund
    res <- subset(all_funds, Fondnamn == fund_name)
    avgift <- res$Avgift
    fondtyp <- res$Fondtyp
    risk <- res$Risk
    samma <- input$samma
    if (!is.null(samma)) {
      if ("Fondtyp"%in%samma) {
        df_f <- subset(df_f, Fondtyp == fondtyp)
      }
      if ("Risk"%in%samma) {
        df_f <- subset(df_f, Risk == risk)
      }
    }
    df_f <- df_f[sort.list(df_f$Avgift),]
    df_f
  })
  get_data_for_table <- reactive({
    data <- filter_funds()
    data <- data[sort.list(data$Avgift),]
    data <- data.table(data)
    data
  })
  
  output$fund_table <- DT::renderDataTable({
    data <- get_data_for_table()
    cols <- c("Fondföretag","Fondid","Fondnamn","Avgift","Avgiftstyp","Kategori","Fondtyp",
              "Etisk","Snitt (årlig)","Snitt (5 år)","Risk","Hållbarhetsprofilen",
              "Klusterbomber","Kemiska vapen","Kärnvapen","Vapen/krigsmateriel","Alkohol",
              "Tobak","Spelverksamhet","Pornografi","Fossilt","Kol","Uran","GMO")
    data[,..cols]
  }, server = TRUE, selection = "single")
  
})
